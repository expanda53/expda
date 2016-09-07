package hu.expanda.expda;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.TextView;

import com.symbol.emdk.barcode.Scanner;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.ArrayList;

import dalvik.system.DexClassLoader;


public class MainActivity extends Activity {
    private exPane pane;
    public static String EXTRA_MSG_KEZELO = "hu.expanda.expda.KEZELO";
    public static String EXTRA_MSG_ITEM = "hu.expanda.expda.ITEM";
    public static Object style = null;
    public static ArrayList<Object> a_style = null;
    public static Symbol symbol = null;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AbsoluteLayout ll = new AbsoluteLayout(this);
//        String xml = loadXml();
        if (symbol==null)   symbol = new Symbol(getApplicationContext());
        if (symbol.getScanner()==null) symbol.initScanner();

        Ini.Create();
        if (Ini.isLandScape())  setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
        else setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
        String xml = "mainmenu.xml";
        Intent intent =this.getIntent();

        String xItem = intent.getStringExtra(EXTRA_MSG_ITEM);
        if (xItem != null && xItem!="") xml = xItem+".xml";


        pane = new exPane(this, ll, xml);


        setContentView(ll);
        pane.getLayout().requestFocus();
/*
        if (!Ini.getLibFile().equalsIgnoreCase("")) {
            String libPath = Environment.getExternalStorageDirectory() +"/" + Ini.getLibFile();
            //String libPath = Ini.getLibraryDir() +"/" + Ini.getLibFile();
            //File file = new File(libPath);
            //if(file.exists()) Log.d(this.getClass().getName(), "lippath exists: " + libPath);
            //else  Log.d(this.getClass().getName(), "lippath not exists: " + libPath);

            try {
                File tmpDir = getDir("dex", 0);
                DexClassLoader classloader = new DexClassLoader(libPath, tmpDir.getAbsolutePath(), null, this.getClass().getClassLoader());
                Class<Object> classToLoad = (Class<Object>) classloader.loadClass("hu.expanda.testlib.testlibrary.testlib");

                extLib = classToLoad.newInstance();
                this.methods = classToLoad.getDeclaredMethods();
                //Method getResult = classToLoad.getMethod("getResult", new Class[]{ViewGroup.class});
                //Object x = getResult.invoke(extLib, pane.getLayout());
                //String res = ((String) x).toString();
                //Log.d(this.getClass().getName(), "getResult: " + res);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
*/
        run();

//        setContentView(R.layout.activity_main);
    }

    private void run(){
        try {
/*
            if (pane.getSqlOnCreate()!=null) {
                pane.showWaitbox("");
                pane.sendGetExecute(pane.getSqlOnCreate(),true);
            }
*/
            if (pane.getLuaOnCreate()!=null) {
//                pane.showWaitbox("");
                pane.luaInit(pane.getLuaOnCreate());
            }
            symbol.setPane(pane);
            //symbol.startRead();

        }
        catch (Exception e){
            e.printStackTrace();
            System.out.println(e.getMessage());
            pane.showMessage("Panel indítás nem sikerült.");
        }
//        pane.hideWaitbox();

    }



    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }



}
