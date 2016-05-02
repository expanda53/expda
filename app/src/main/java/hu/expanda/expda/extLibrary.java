package hu.expanda.expda;

import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import dalvik.system.DexClassLoader;

/**
 * Created by kende on 2016. 04. 29..
 */
public class extLibrary {
    private exPane pane;
    private ViewGroup layout;
    private Method[] methods = null;
    private Object extLib = null;

    public extLibrary (exPane pane){

        this.pane = pane;
        this.layout = pane.getLayout();

        if (!Ini.getLibFile().equalsIgnoreCase("")) {
            String libPath = Environment.getExternalStorageDirectory() +"/" + Ini.getLibFile();
            //String libPath = Ini.getLibraryDir() +"/" + Ini.getLibFile();
            //File file = new File(libPath);
            //if(file.exists()) Log.d(this.getClass().getName(), "lippath exists: " + libPath);
            //else  Log.d(this.getClass().getName(), "lippath not exists: " + libPath);

            try {
                File tmpDir = pane.getContext().getDir("dex", 0);
                DexClassLoader classloader = new DexClassLoader(libPath, tmpDir.getAbsolutePath(), null, this.getClass().getClassLoader());
                Class<Object> classToLoad = (Class<Object>) classloader.loadClass("hu.expanda.testlib.testlibrary.testlib");

                this.extLib = classToLoad.newInstance();
                this.methods = classToLoad.getDeclaredMethods();
                //Method getResult = classToLoad.getMethod("getResult", new Class[]{ViewGroup.class});
                //Object x = getResult.invoke(extLib, pane.getLayout());
                //String res = ((String) x).toString();
                //Log.d(this.getClass().getName(), "getResult: " + res);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public String runMethod(String par) throws InvocationTargetException, IllegalAccessException {
        String result = "";
        if (par!=null) {
            String[] p = this.pane.extFuncInit(par);
            String[] params = {};
            if (p[0]!=null) {
                String methodName = p[0];
                if (p.length > 1) {
                    params = new String[p.length - 1];
                    for (int i = 1; i < p.length; i++) {
                        params[i - 1] = p[i];
                    }

                }

                if (this.extLib != null) {
                    if (methodName != null) {
                        for (Method m : this.methods) {
                            String name = m.getName().toString();
                            if (methodName.equalsIgnoreCase(name)) {
                                Log.d("extlibrary.runMethod", name + ": ok");
                                Object x = m.invoke(this.extLib, this.layout, params);
                                result = ((String) x).toString();
                            }
                        }
                    }
                }
            }
        }
        return result;
    }
}
