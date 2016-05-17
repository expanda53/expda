package hu.expanda.expda;

import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import java.io.File;
import java.lang.reflect.Array;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;

import dalvik.system.DexClassLoader;

/**
 * Created by kende on 2016. 04. 29..
 */
public class extLibrary {
    private static exPane pane;
    private static ViewGroup layout;
    private static Method[] methods = null;
    private static Object extLib = null;
    private static boolean created = false;
    public static void Create(exPane pane) {
        extLibrary.pane = pane;
        extLibrary.layout = pane.getLayout();

        if (!created) {
            if (!Ini.getLibFile().equalsIgnoreCase("")) {
                String libPath = Environment.getExternalStorageDirectory() +"/" + Ini.getLibFile();
                //String libPath = Ini.getLibraryDir() +"/" + Ini.getLibFile();
                //File file = new File(libPath);
                //if(file.exists()) Log.d(this.getClass().getName(), "lippath exists: " + libPath);
                //else  Log.d(this.getClass().getName(), "lippath not exists: " + libPath);

                try {
                    File tmpDir = pane.getContext().getDir("dex", 0);
                    DexClassLoader classloader = new DexClassLoader(libPath, tmpDir.getAbsolutePath(), null, extLibrary.class.getClassLoader());
                    Class<Object> classToLoad = (Class<Object>) classloader.loadClass("hu.expanda.testlib.testlibrary.testlib");
                    if (Ini.getPhpUrl()!=null) {
                        //constructor hivas 1 argumentummal
                        Constructor c = classToLoad.getDeclaredConstructor(String.class);
                        c.setAccessible(true);
                        extLibrary.extLib = (Object) c.newInstance(Ini.getPhpUrl());
                    }
                    else {
                        //argumentum nelkuli contructor hivas
                        extLibrary.extLib = classToLoad.newInstance();
                    }

                    extLibrary.methods = classToLoad.getDeclaredMethods();
                    //Method getResult = classToLoad.getMethod("getResult", new Class[]{ViewGroup.class});
                    //Object x = getResult.invoke(extLib, pane.getLayout());
                    //String res = ((String) x).toString();
                    //Log.d(this.getClass().getName(), "getResult: " + res);

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            created = true;
        }


    }
    public static String runMethod(String par) throws InvocationTargetException, IllegalAccessException {
        String result = "";
        if (par!=null) {
            String[] p = extLibrary.pane.extFuncInit(par);
            String[] params = {};
            if (p[0]!=null) {
                String methodName = p[0];
                if (p.length > 1) {
                    params = new String[p.length - 1];
                    for (int i = 1; i < p.length; i++) {
                        params[i - 1] = p[i];
                    }

                }

                if (extLibrary.extLib != null) {
                    if (methodName != null) {
                        for (Method m : extLibrary.methods) {
                            String name = m.getName();
                            if (methodName.equalsIgnoreCase(name)) {
                                Log.d("extlibrary.runMethod", name + " found");
                                Object x = m.invoke(extLibrary.extLib, extLibrary.layout, params);
                                Log.d("extlibrary.runMethod", name + " run: ok");
                                result = ((ArrayList<String>) x).toString();
                                Log.d("extlibrary.runMethod", name + " result: " + result);

                                ArrayList<String> r = pane.getDbc().Query("select ID,VALUE from LOG order by id");
                                Log.d("expda.controlQuery", name + " result: " + r.toString());
                            }
                        }
                    }
                }
            }
        }
        return result;
    }

}
