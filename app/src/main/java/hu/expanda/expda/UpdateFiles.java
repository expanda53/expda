package hu.expanda.expda;

/**
 * Created by Encsi on 2015.03.01..
 */

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectOutput;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.ArrayList;


public class UpdateFiles extends AsyncTask<String, String, String> {
    private HttpURLConnection connection=null;

    public ArrayList getResult() {
        return result;
    }

    public void setResult(ArrayList result) {
        this.result = result;
    }
    private String charset = "UTF-8";
    private String URL = "";
    private String URLRoot = "";
    private ArrayList result = null;
    private String[] aktItem = {"",""};
    private Context c;
    //convert InputStream to String
    private static ArrayList IStreamToString(InputStream is) {

        BufferedReader br = null;
        ArrayList response = new ArrayList();
        String line;
        try {

            br = new BufferedReader(new InputStreamReader(is));
            while ((line = br.readLine()) != null) {
                response.add(line);
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return response;

    }



    public UpdateFiles(String url,Context c) throws Exception{

        this.setURL(url);

        URL urlo = null;
        try {
            urlo = new URL(url);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        URLRoot = getURL();
        URLRoot = URLRoot.replace(urlo.getFile(),"");
        this.c = c;

    }

    private boolean updateFile(String... aktFile){
        String status = "";
        String fileNev = "";
        String verzio = "";
        if (aktFile.length > 0) fileNev = aktFile[0];
        if (aktFile.length > 1) verzio = aktFile[1];
        aktItem = aktFile;
        if (!fileNev.equals("")) {
            if (verzio.equalsIgnoreCase("X")) {
                //torles
                File file = new File(Ini.getRootDir(), fileNev);
                if (file.delete()) status = "Törölve:" + fileNev;
                if (status != "") publishProgress(status);
                return true;
            } else {
                String content = StringFunc.getFile(fileNev);
                if (content == null || content == "") {
                    content = ""; //nem talalhato ilyen file, fel kell irni
                    status = "Új:" + fileNev;
                }
                //ha megtalalhato benne az uj verzioszam, nem kell frissiteni
                if (content.indexOf("<verzio>" + verzio + "</verzio>") > -1) return false;
                else {
                    //az uj verzio nem talalhato a fileban, frissiteni kell
                    if (content != "" && content != null) status = "Frissítve:" + fileNev;
                    ArrayList response = downloadFile(getURLRoot() + "/" + fileNev);
                    File file = new File(Ini.getRootDir(), fileNev);
                    String dir = file.getParent();
                    File fdir = new File(dir);
                    fdir.mkdirs();
                    try {
                        file.createNewFile();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    FileOutputStream fileOutputStream = null;
                    try {
                        fileOutputStream = new FileOutputStream(file);
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    }
                    for (int i = 0; i < response.size(); i++) {
                        String aktrow = response.get(i).toString();
                        try {
                            fileOutputStream.write(aktrow.getBytes());
                            fileOutputStream.write("\n".getBytes());
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    try {
                        fileOutputStream.flush();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    try {
                        fileOutputStream.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    if (status != "") publishProgress(status);

                    return true;
                }
            }
        }
        else {
            return true;
        }

    }

    public ArrayList downloadFile(String urlStr) {
        URL url = null;
        try {
            url = new URL(urlStr);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }

        try {
            connection = (HttpURLConnection) url.openConnection();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            connection.setRequestMethod("GET");
        } catch (ProtocolException e) {
            e.printStackTrace();
        }
        //connection.setDoOutput(true);
        connection.setConnectTimeout(10000);
        connection.setReadTimeout(10000);
        try {
            connection.connect();
        } catch (IOException e) {
            e.printStackTrace();
        }


        InputStream inputStream = null;
        try {
            inputStream = connection.getInputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }
        //updatefiles.xml beolvasas arraylistbe
        ArrayList response = IStreamToString(inputStream);
        return response;

    }

    public String updateAllFiles(String path) throws Exception{
            try {
                ArrayList response = downloadFile(getURL());
                //arraylist feldolgozasa, minden sor egy frissitendo file
                for(int i=0;i<response.size();i++) {
                    String aktsor = response.get(i).toString();
                    if (!aktsor.equals("")) {
                        String[] sor = aktsor.split(";");
                        updateFile(sor);
                    }
                }
                MainActivity.startUpdate = true;

            } catch (Exception e) {
                Log.e("exPda", "Beállítás frissítési hiba...");
                Log.e("exPda", e.getMessage());
            }

            return path;
    }

    public String getURL() {
        return URL;
    }

    public void setURL(String URL) {
        this.URL = URL;
    }


    @Override
    protected String doInBackground(String... params) {
        this.setURL(params[0]);
        String res = "";
        try {
            res = this.updateAllFiles(params[1]);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    @Override
    protected void onProgressUpdate(String... progress) {
        new exToast(c,progress[0],2).start();
        /*Toast.makeText(
                c,
                progress[0],
                Toast.LENGTH_SHORT).show();
        */

    }


    public String getURLRoot() {
        return URLRoot;
    }
}
