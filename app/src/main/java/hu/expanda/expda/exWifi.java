package hu.expanda.expda;

/**
 * Created by kende on 2016. 10. 25..
 */
import android.app.Activity;
import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;

public class exWifi {
    private static WifiManager wifiMan;
    private static WifiInfo wifiInfo;

    public exWifi (Context c) {
        if (wifiMan==null)  wifiMan = (WifiManager) ((Activity)c).getSystemService(Context.WIFI_SERVICE);


    }
    public static WifiManager getWifiManager() {

        return wifiMan;
    }
    public static boolean isWifiEnabled(){

        return getWifiManager().getWifiState() ==WifiManager.WIFI_STATE_ENABLED;
    }
    public static WifiInfo getWifiInfo() {

        return wifiInfo = getWifiManager().getConnectionInfo();

    }
    public static int getWifiStrength(){
            return getWifiManager().calculateSignalLevel (getWifiInfo().getRssi(),5);
    }

    public static String getMacAddress(){
        return getWifiInfo().getMacAddress();
    }





}
