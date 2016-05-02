package hu.expanda.expda;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Encsi on 2015.02.23..
 */
public class exGridAdapter extends BaseAdapter {
    private Context c;
    private int colNum;

    private List<Object> mItems = new ArrayList<Object>();
    private List<ObjTableCell> mItems2 = new ArrayList<ObjTableCell>();
    private void explode(){
        for (int i=0;i<mItems.size();i++){
            Object o = mItems.get(i);
            for (int j=0 ; j< ((ArrayList<ObjTableCell>)o).size();j++) {
                ObjTableCell cell = ((ArrayList<ObjTableCell>) o).get(j);
                mItems2.add(cell);
            }
        }

    }
    public exGridAdapter(Context context, ArrayList items,int colNum) {
        c = context;
        mItems = items;
        this.explode();
       this.colNum = colNum;
    }
    @Override
    public int getCount() {
        return mItems2.size();
    }

    @Override
    public Object getItem(int position) {
        return mItems2.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        exGridRow mrow;
        if (convertView == null) {

            mrow = new exGridRow(c, mItems2.get(position));
        } else {
            mrow = (exGridRow) convertView;

            mrow.setItem(c,mItems2.get(position));
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
