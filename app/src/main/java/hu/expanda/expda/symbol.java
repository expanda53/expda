package hu.expanda.expda;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import com.symbol.emdk.EMDKManager;
import com.symbol.emdk.EMDKResults;
import com.symbol.emdk.barcode.BarcodeManager;
import com.symbol.emdk.barcode.ScanDataCollection;
import com.symbol.emdk.barcode.Scanner;
import com.symbol.emdk.barcode.ScannerException;
import com.symbol.emdk.barcode.ScannerInfo;
import com.symbol.emdk.barcode.ScannerResults;
import com.symbol.emdk.barcode.StatusData;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Encsi on 2016.07.07..
 */
class Symbol implements Scanner.DataListener, EMDKManager.EMDKListener,Scanner.StatusListener {
    private EMDKManager emdkManager = null;
    private BarcodeManager barcodeManager = null;
    private Scanner scanner = null;
    private List<ScannerInfo> deviceList = null;
    private exPane pane;
    public Symbol(Context c) {
        if (MainActivity.useSymbol) {
            if (deviceList == null) deviceList = new ArrayList<ScannerInfo>();
            EMDKResults results = EMDKManager.getEMDKManager(c, this);
        }
    }

    public void setPane(exPane pane){
        this.pane = pane;
    }

    @Override
    public void onData(ScanDataCollection scanDataCollection) {
        if ((scanDataCollection != null) && (scanDataCollection.getResult() == ScannerResults.SUCCESS)) {
            ArrayList<ScanDataCollection.ScanData> scanData = scanDataCollection.getScanData();
            for(ScanDataCollection.ScanData data : scanData) {

                String dataString =  data.getData();
                Log.d("scanner",dataString);
                try {
                    new AsyncDataUpdate().execute(dataString);
                }
                catch (Exception e){
                    e.printStackTrace();
                    System.out.println(e.getMessage());

                }


            }
        }

    }

    private class AsyncDataUpdate extends AsyncTask<String, Void, String> {

        @Override
        protected String doInBackground(String... params) {

            return params[0];
        }

        protected void onPostExecute(String result) {

            if (result != null && pane!=null) {
                if (pane.getAktBCodeObj()!=null) {
                    pane.getAktBCodeObj().setPane(pane);
                    pane.getAktBCodeObj().valueTo(result);
                    String msg = pane.getAktBCodeObj().getSqlAfterTrigger();
                    pane.sendGetExecute(msg, true);
                    msg = pane.getAktBCodeObj().getLuaAfterTrigger();
                    pane.luaInit(msg);
                    msg = pane.getAktBCodeObj().getExtFunctionAfterTrigger();
                    try {
                        extLibrary.runMethod(msg);
                    } catch (InvocationTargetException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }



    public  void initScanner(){
        if (scanner == null) {

            if ((deviceList != null) && (deviceList.size() != 0)) {
                scanner = barcodeManager.getDevice(deviceList.get(0));
            }
            else {
                //textViewStatus.setText("Status: " + "Failed to get the specified scanner device! Please close and restart the application.");
                return;
            }
        }
        if (scanner != null) {

            scanner.addDataListener(this);
            scanner.addStatusListener(this);

            try {
                scanner.enable();
            } catch (ScannerException e) {

                //textViewStatus.setText("Status: " + e.getMessage());
            }
            scanner.triggerType = Scanner.TriggerType.HARD;

        }else{
            //textViewStatus.setText("Status: " + "Failed to initialize the scanner device.");
        }

    }

    @Override
    public void onOpened(EMDKManager emdkManager) {

        this.emdkManager = emdkManager;

        // Acquire the barcode manager resources
        barcodeManager = (BarcodeManager) emdkManager.getInstance(EMDKManager.FEATURE_TYPE.BARCODE);
        deviceList = barcodeManager.getSupportedDevicesInfo();
        // Add connection listener
        if (barcodeManager != null) {
           // barcodeManager.addConnectionListener(this);
            initScanner();
        }

    }

    @Override
    public void onClosed() {
        stopRead();
        try {
            scanner.disable();
            scanner.removeDataListener(this);
            scanner.removeStatusListener(this);
            scanner.release();
        } catch (ScannerException e) {
            e.printStackTrace();
        }

    }

    @Override
    public void onStatus(StatusData statusData) {
        StatusData.ScannerStates state = statusData.getState();
        String statusString;

        switch(state) {
            case IDLE:
                statusString = statusData.getFriendlyName()+" is enabled and idle...";
                    try {
                        // An attempt to use the scanner continuously and rapidly (with a delay < 100 ms between scans)
                        // may cause the scanner to pause momentarily before resuming the scanning.
                        // Hence add some delay (>= 100ms) before submitting the next read.
                        try {
                            Thread.sleep(100);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }

                        scanner.read();
                    } catch (ScannerException e) {
                        statusString = e.getMessage();
                    }

                break;
            case WAITING:
                statusString = "Scanner is waiting for trigger press...";
                break;
            case SCANNING:
                statusString = "Scanning...";
                break;
            case DISABLED:
                statusString = statusData.getFriendlyName()+" is disabled.";
                break;
            case ERROR:
                statusString = "An error has occurred.";
                break;
            default:
                break;
        }

    }

    public Scanner getScanner(){
        return scanner;
    }

    public void startRead(){
        if (getScanner()!=null) {
            try {
                getScanner().read();
            } catch (ScannerException e) {
                e.printStackTrace();
            }
        }

    }
    public void stopRead() {
        if (getScanner()!=null) {
            try {
                getScanner().cancelRead();
            } catch (ScannerException e) {
                e.printStackTrace();
            }
        }
    }

}
