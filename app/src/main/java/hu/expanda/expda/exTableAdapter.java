package hu.expanda.expda;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.Inflater;

/**
 * Created by Encsi on 2015.02.23..
 */
public class exTableAdapter extends BaseAdapter {
    private Context c;
    private ObjTable obj;

    private List<Object> mItems = new ArrayList<Object>();

    public exTableAdapter(Context context, ArrayList items,ObjTable obj) {
        c = context;
        mItems = items;
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

            mrow = new exTableLine(c, mItems.get(position),obj);
        } else {
            mrow = (exTableLine) convertView;
            mrow.setItem(c,mItems.get(position));



/*
            String name = mItems.get(position).getName();
            btv.setNameText(name);
            String number = mShow.get(position).getNumber();
            if (number != null) {
                btv.setNumberText("Mobile: " + mShow.get(position).getNumber());
            }

*/

/*
            String name = mItems.get(position).toString();
            mrow.setName(name);
*/
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
