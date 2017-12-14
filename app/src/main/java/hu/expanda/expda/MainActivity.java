package hu.expanda.expda;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Point;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsoluteLayout;

/*
import com.symbol.emdk.barcode.Scanner;
import com.symbol.emdk.barcode.ScannerException;
*/
import java.util.ArrayList;
import java.util.HashMap;


public class MainActivity extends Activity {
    private exPane pane;
    public static String EXTRA_MSG_KEZELO = "hu.expanda.expda.KEZELO";
    public static String EXTRA_MSG_ITEM = "hu.expanda.expda.ITEM";
    public static String EXTRA_MSG_GLOBALS = "hu.expanda.expda.GLOBALS";
    public static Object style = null;
    public static ArrayList<Object> a_style = null;
    public static Symbol symbol = null;
    public static boolean startUpdate = true;
    private static boolean scannerEnabled = false;
    public static boolean useSymbol = false;
    public static exMedia mediaFiles;
    public static DisplayMetrics dmetrics;
    public static Activity act;
    public static int displayWidth = 0;
    public static HashMap<String,Object> luamap = null;
    public static HashMap<String,Object> xmlmap = null;
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
        ArrayList<String> globals ;
        dmetrics = getResources().getDisplayMetrics();
        AbsoluteLayout ll = new AbsoluteLayout(this);
//        String xml = loadXml();
        if(android.os.Build.MANUFACTURER.contains("Zebra Technologies") || android.os.Build.MANUFACTURER.contains("Motorola Solutions") ){
                useSymbol = true;
                if (symbol==null)   symbol = new Symbol(getApplicationContext());
                if (symbol.getScanner()==null) symbol.initScanner();

        }

        Ini.Create();

        String startXml = Ini.getStartXML();
        String xml = startXml;
        Intent intent =this.getIntent();

        String xItem = intent.getStringExtra(EXTRA_MSG_ITEM);
        if (xItem != null && xItem!="") xml = xItem+".xml";
        if (xml.equalsIgnoreCase(startXml)) {
            Ini.setCreated(false);
            Ini.Create();
        }
        if (Ini.isLandScape())  setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
        else setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);

        Display display = getWindowManager().getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        displayWidth = size.x;

        new exWifi(this);
        /*if (startUpdate && exWifi.isWifiEnabled() && exWifi.getWifiStrength()>0) {
            try {
                startUpdate = false;
                //File dir = this.getFilesDir();
                UpdateFiles updateFiles = new UpdateFiles(Ini.getUpdateURL(),this);
                //String[] s={"http://192.168.1.105/updatefiles.xml",dir.getAbsolutePath()};
                String[] s = {Ini.getUpdateURL(), Ini.getIniDir()};

                updateFiles.execute(s);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        */
        //mp3 fileok felolvasása, mediafiles arraylistbe
        if (mediaFiles==null) mediaFiles = new exMedia(this);
        act=this;
        pane = new exPane(this, ll);
        pane.Build(xml);

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

                pane.luaInit(pane.getLuaOnCreate());
            }
            /*symbol.setPane(pane);*/


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

    @Override
    protected void onResume() {

        super.onResume();
        /*
        if (scannerEnabled) try {
            symbol.getScanner().enable();
        } catch (ScannerException e) {
            e.printStackTrace();
        }
        */

    }

    @Override
    protected void onPause() {
        super.onPause();
        /*
        scannerEnabled = symbol.getScanner().isEnabled();
        if (scannerEnabled)
        try {
            symbol.getScanner().disable();
        } catch (ScannerException e) {
            e.printStackTrace();
        }
        */
    }

    @Override
    public void onBackPressed() {
        if (!Ini.isBackButtonDisabled()) super.onBackPressed();

    }

/*
    @Override
    protected void onStop(){
        mediaFiles.killAll();
        super.onStop();

    }
*/
    public String getImei(){
        TelephonyManager telephonyManager = (TelephonyManager)getSystemService(Context.TELEPHONY_SERVICE);
        return telephonyManager.getDeviceId();
    }
    public void hideSoftKeyboard(View view){
        if (!Ini.isSoftKeyboardNeed()) {
            getWindow().setSoftInputMode(
                    WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN
            );
            InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }

}
