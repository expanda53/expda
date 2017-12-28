package hu.expanda.expda;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.os.ParcelUuid;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Set;
import java.util.UUID;

/**
 * Created by kende on 2017. 12. 27..
 */

public class exBluetooth {
    class btClass{
        String deviceName="";
        String MAC="";
        int devClass=0;
    }
    private BluetoothAdapter mBluetoothAdapter;
    private BluetoothSocket mBluetoothSocket;
    BluetoothDevice mBluetoothDevice;
    private InputStream mmInStream;
    private OutputStream mmOutStream;

    public exBluetooth() {
        super();
    }

    public ArrayList<btClass> getPairedDevices(){
        if (this.mBluetoothAdapter==null){
            this.mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        }

        ArrayList<btClass> btarray = new ArrayList<>();
        Set<BluetoothDevice> pairedDevices = mBluetoothAdapter.getBondedDevices();
        if (pairedDevices.size() > 0) {
            // There are paired devices. Get the name and address of each paired device.
            for (BluetoothDevice device : pairedDevices) {
                btClass b=new btClass();
                b.deviceName = device.getName();
                b.MAC = device.getAddress(); // MAC address
                b.devClass = device.getBluetoothClass().getDeviceClass();
                btarray.add(b);
            }
        }
        return btarray;
    }

    public boolean connect(String mac){
        boolean res = false;
        mBluetoothDevice = mBluetoothAdapter.getRemoteDevice(mac);
        try {
            ParcelUuid[] uuids = mBluetoothDevice.getUuids();

            mBluetoothSocket = mBluetoothDevice.createRfcommSocketToServiceRecord(uuids[0].getUuid());
            mBluetoothAdapter.cancelDiscovery();

            mBluetoothSocket.connect();
            mmOutStream = mBluetoothSocket.getOutputStream();
            res=true;
        } catch (IOException e) {
            try {
                mBluetoothSocket.close();
            } catch (IOException e1) {
                e1.printStackTrace();
            }
            e.printStackTrace();
        }
        return res;
    }

    public boolean close(){
        boolean res = false;
        try {
            mBluetoothSocket.close();
            res = true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return res;
    }

    public boolean write(byte[] bytes){
        boolean res = false;
        try {
            mmOutStream.write(bytes);
            res=true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return res;
    }
}
