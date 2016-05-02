package hu.expanda.expda;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.AdapterView;
import android.widget.GridView;

import java.lang.reflect.Array;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by Encsi on 2015.01.31..
 */


public class exGrid extends GridView{
    private ObjTable obj;
    private Context context;
    private exPane pane;
    public int selectedRowIndex;

    public ArrayList<ObjTableCell> getSelectedRow() {
        return (ArrayList<ObjTableCell>)selectedRow;
    }

    public Object selectedRow;
    public exGrid(Context parent, Object table, ViewGroup layout, exPane pane){
        super(parent);
        this.context = parent;
        this.pane = pane;
        this.obj=(ObjTable)table;
        //this.refresh(null);
        this.setVisibility(obj.getVisibility());
        int width = obj.getWidth();
        if (width==0) {
            width=60;
            getObj().setWidth(width);
        }

        int height = obj.getHeight();
        if (height==0) {
            height=20;
            getObj().setHeight(height);
        }
        if (obj.getBackColor()!=-1) this.setBackgroundColor(obj.getBackColor());
        this.setTop(obj.getTop());
        this.setLeft(obj.getLeft());
        this.setMinimumHeight(obj.getHeight());
        this.setMinimumWidth(obj.getWidth());
        layout.addView(this,new AbsoluteLayout.LayoutParams(getObj().getWidth(), getObj().getHeight(), getObj().getLeft(), getObj().getTop()));
        this.setTag(obj.getName());
        final exGrid lv = this;
        this.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                ArrayList a = new ArrayList();

                lv.selectedRowIndex = position/lv.getNumColumns();
                for (int i = lv.selectedRowIndex * lv.getNumColumns(); i<(lv.selectedRowIndex * lv.getNumColumns())+lv.getNumColumns();i++ ) {
                    a.add(lv.getItemAtPosition(i));
                }
                selectedRow = a;
                getPane().luaInit(getObj().getLuaAfterClick());
                try {
                    getPane().getExtLib().runMethod(getObj().getExtFunctionAfterClick());
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }


            }
        });


//		System.out.println(this.getData("NAME"));


    }

    public void setBounds(String command, int val){
        if (command.equalsIgnoreCase("SETTOP")) this.setTop1(val);
        if (command.equalsIgnoreCase("SETWIDTH")) this.setWidth1(val);
        if (command.equalsIgnoreCase("SETHEIGHT")) this.setHeight1(val);
        if (command.equalsIgnoreCase("SETLEFT")) this.setLeft1(val);
    }

    public void setBgColor(String colorstr){
        this.getObj().setBackColor(colorstr);
        this.setBackgroundColor(Color.parseColor(colorstr));
    }


    public void setWidth1(int width){
        getObj().setWidth(width);
        this.setMinimumWidth(getObj().getWidth());

    }
    public void setHeight1(int height){
        getObj().setHeight(height);
        this.setMinimumHeight(getObj().getHeight());
    }


    public void setTop1(int top){
        getObj().setTop(top);
        this.setTop(getObj().getTop());

    }



    public void setLeft1(int left){
        getObj().setLeft(left);
        this.setLeft(getObj().getLeft());
    }
    private String[] parseResponse(String row){
        String[] curr = row.replace('[', ' ').trim().split("=");
        return curr;
    }



    public void refresh(ArrayList res){
//		tabla feltoltese
//        this.removeAll();
        int numCol = -1;
        ArrayList a = new ArrayList();
        exGridAdapter myAd = (exGridAdapter) this.getAdapter();

        if (myAd!=null) {
            myAd.getAll().clear();
        }
        for(int i=0;i<res.size();i++){
            String aktrow = res.get(i).toString();
            String[] row = aktrow.split("]]");
            if (numCol==-1) {
                numCol = row.length;
                this.setNumColumns(numCol);
                this.setStretchMode(STRETCH_COLUMN_WIDTH);
                this.setColumnWidth(90);

            }
            ArrayList<ObjTableCell> currentLine = new ArrayList<ObjTableCell>();
            for (int j=0;j<row.length ;j++){

                String[] temps = parseResponse(row[j]);
                int index = this.getObj().getColumnIndexByName(temps[0]);
                if (temps.length>1 && index>-1) {
                    String[] values = temps[1].split("@@");
                    String aktData = values[0];
                    String aktStyle = null;
                    if (values.length>1){
                        for (int k=1;k<values.length;k++){
                            String aktitem = values[k];
                            String[] itemprops = aktitem.split(":");
                            //if (itemprops[0].equalsIgnoreCase("BGCOLOR")) item.setBackground(Colorfunc.getColor(itemprops[1], SWT.COLOR_WHITE));
                            //if (itemprops[0].equalsIgnoreCase("FONT_COLOR") || itemprops[0].equalsIgnoreCase("FONTCOLOR") || itemprops[0].equalsIgnoreCase("TEXTCOLOR")) item.setForeground(Colorfunc.getColor(itemprops[1], SWT.COLOR_BLACK));
                            if (itemprops[0].equalsIgnoreCase("STYLE")) aktStyle = itemprops[1];
                        }
                    }
                    ObjTableCell cell = new ObjTableCell(aktStyle,aktData,temps[0],index,-1);
                    currentLine.add(cell);
                }
                
            }
            a.add(currentLine);

        }
        if (myAd!=null) {
            myAd.setAll(a);
            myAd.notifyDataSetChanged();

        }
        else {
            this.setAdapter(new exGridAdapter(context, a,this.getNumColumns()));
        }
    }




    public ObjTable getObj() {
        return obj;
    }


    public exPane getPane() {
        return pane;
    }
}
