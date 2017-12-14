package hu.expanda.expda;

/**
 * Created by Encsi on 2015.03.01..
 */

        import android.app.Application;
        import android.app.ProgressDialog;
        import android.content.Context;
        import android.os.AsyncTask;
        import android.util.Log;
        import android.view.Window;

        import java.io.BufferedReader;
        import java.io.IOException;
        import java.io.InputStream;
        import java.io.InputStreamReader;
        import java.net.HttpURLConnection;
        import java.net.MalformedURLException;
        import java.net.URL;
        import java.net.URLEncoder;
        import java.util.ArrayList;


public class PHPClient extends AsyncTask<String, Void, ArrayList> {
    private HttpURLConnection connection=null;

    public ArrayList getResult() {
        return result;
    }

    public void setResult(ArrayList result) {
        this.result = result;
    }

    private String charset = "UTF-8";
    private String URL = "";
    private ArrayList result = null;
    //convert InputStream to String
    ProgressDialog progressDialog;
    private Context c;
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


    public PHPClient(String url) throws Exception{

        this.setURL(url);
    }



    public ArrayList sendMessage(String msg) throws Exception{
        try {
//            MainActivity.showProgress();
            connection = (HttpURLConnection) new URL(getURL()).openConnection();
            connection.setDoOutput(true);
            connection.setDoInput(true);
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(0);
            connection.setReadTimeout(0);
            connection.setRequestProperty("Accept-Charset", this.charset);
            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=" + this.charset);


        } catch (MalformedURLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }


        String[] urlTags = msg.split(" ");
        String newUrl = "";
        if (urlTags.length>0) {
            for (int ix=0;ix<urlTags.length;ix++) {
                String curr = URLEncoder.encode(urlTags[ix], charset);
//				String curr = urlTags[ix];
                if (ix==0) newUrl += "?command="+curr;
                else newUrl += "&p"+Integer.toString(ix)+"="+curr;
            }
        }
//		System.out.println(this.getURL() + newUrl);
        ArrayList response = new ArrayList();
        try {
            connection.getOutputStream().write((this.getURL() + newUrl).getBytes(this.charset));
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        finally {
            try {
                connection.getOutputStream().close();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        InputStream resp=null;
        try {
            resp = connection.getInputStream();
            response = IStreamToString(resp);



        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        finally {
            try {
                resp.close();

            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
//        MainActivity.hideProgress();
       return response;
    }

    public String getURL() {
        return URL;
    }

    public void setURL(String URL) {
        this.URL = URL;
    }


    @Override
    protected ArrayList doInBackground(String... params) {
            this.setURL(params[0]);
            ArrayList a = null;
            try {
                a = this.sendMessage(params[1]);
            } catch (Exception e) {
                e.printStackTrace();
            }
            setResult(a);
            return a;
    }

    @Override
    protected void onPostExecute(ArrayList result) {
        if (progressDialog.isShowing()) {
            progressDialog.dismiss();
        }

    }


    @Override
    protected void onPreExecute() {
        if (progressDialog == null) {
            progressDialog = new ProgressDialog(this.getContext());
            progressDialog.setMessage("Várjon...");
            progressDialog.setCanceledOnTouchOutside(false);
            progressDialog.setCancelable(false);
            progressDialog.show();
        }
    }

    public Context getContext() {
        return c;
    }

    public void setContext(Context c) {
        this.c = c;
    }
}
