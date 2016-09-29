package hu.expanda.expda;

import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.lang.reflect.Array;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.Inflater;

/**
 * Created by Encsi on 2015.02.23..
 */
public class exTableAdapter extends BaseAdapter {
    private Context c;
    private ObjTable obj;
    private exTable eTable;
    private List<Object> mItems = new ArrayList<Object>();

    public exTableAdapter(Context context, ArrayList items,ObjTable obj,exTable eTable) {
        c = context;
        mItems = items;
        this.eTable = eTable;
        this.obj = obj;
    }
    @Override
    public int getCount() {
        return mItems.size();
    }

    @Override
    public Object getItem(int position) {
        return mItems.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        exTableLine mrow;
        if (convertView == null) {

            mrow = new exTableLine(c, mItems.get(position),obj,eTable);
        } else {
            mrow = (exTableLine) convertView;
            mrow.setItem(c,mItems.get(position));
        }

        final int pos = position;
        View.OnClickListener listener = new View.OnClickListener() {
            public void onClick(View v) {
                eTable.selectedRowIndex = pos;
                eTable.selectedRow  = eTable.getItemAtPosition(pos);
                if (eTable.getPane() != null) {
                    eTable.getPane().luaInit(eTable.getObj().getLuaAfterClick());
                    try {
                        eTable.getPane().getExtLib().runMethod(eTable.getObj().getExtFunctionAfterClick());
                    } catch (InvocationTargetException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    }
                }
            }
        };
        mrow.setOnClickListener(listener);

        for (int i = 0; i < mrow.getChildCount(); i++) {
            View aktView = mrow.getChildAt(i);
            aktView.setOnClickListener(listener);
            if (aktView instanceof exPanel) {
                if ( ((exPanel)aktView).getChildCount()>0) {
                    for (int j = 0; j < ((exPanel)aktView).getChildCount(); j++) {
                        View aktTv = ((exPanel)aktView).getChildAt(i);
                        aktTv.setOnClickListener(listener);
                    }
                }
            }

        }






            return mrow;
    }

    public List<Object> getAll(){
        return mItems;
    }
    public void setAll(ArrayList<Object> items){
        mItems=items;
    }
}
