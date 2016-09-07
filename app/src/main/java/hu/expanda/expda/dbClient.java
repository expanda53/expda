package hu.expanda.expda;

import android.content.Context;
import java.util.ArrayList;

/**
 * Created by Encsi on 2015.04.17..
 */
public final class dbClient  {
    String sql = null;
    private static ArrayList<String> result = null;
    private static dbHelper db = null;

    public dbClient (Context c) {

        if (db==null)  {
            db = new dbHelper(c,Ini.getDbMeta());
        }
    }


    public static  ArrayList<String> Query(String... params) {
        ArrayList<String> res = db.Query(params[0]);
        db.closeDB();
        return  res;

    }

    public static  void Exec(String... params) {
        db.Exec(params[0]);
        db.closeDB();
    }


}
