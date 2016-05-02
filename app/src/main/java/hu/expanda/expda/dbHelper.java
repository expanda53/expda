package hu.expanda.expda;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Encsi on 2015.04.06..
 */
public class dbHelper extends SQLiteOpenHelper

{
    private static final String DATABASE_NAME = "expda";
    private static final int DATABASE_VERSION = 6;
    private String[] CStrings = {};
    private static final String LOG = dbHelper.class.getName();

//    private static final String CREATE_TABLE_TODO = "CREATE TABLE "
//            + TABLE_TODO + "(" + KEY_ID + " INTEGER PRIMARY KEY," + KEY_TODO
//            + " TEXT," + KEY_STATUS + " INTEGER," + KEY_CREATED_AT
//            + " DATETIME" + ")";
//
    public dbHelper(Context context, String[] createString) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.CStrings = createString;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        for (int i=0; i<CStrings.length;i++ ) {
            db.execSQL(CStrings[i]);
        }
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.w(dbHelper.class.getName(),
                "Upgrading database from version " + oldVersion + " to "
                        + newVersion + ", which will destroy all old data");
        db.execSQL("DROP TABLE IF EXISTS LOG" );
        onCreate(db);
    }

    public ArrayList<String> Query(String sql){
        ArrayList<String> rows = new ArrayList<String>();


        Log.e(LOG, sql);

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(sql, null);

        // looping through all rows and adding to list
        if (c.moveToFirst()) do {
            String row = "";
            for (int i =0 ; i< c.getColumnCount();i++) {
                row+="[[" + c.getColumnName(i)+"="+c.getString(i)+"]]";
            }
            rows.add(row);
        } while (c.moveToNext());

        return rows;
    }

    public void Exec(String sql){
        Log.e(LOG, sql);
        SQLiteDatabase db = this.getWritableDatabase();
        db.execSQL(sql);
    }

    public void closeDB() {
        SQLiteDatabase db = this.getReadableDatabase();
        if (db != null && db.isOpen())
            db.close();
    }
}
