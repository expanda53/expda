package hu.expanda.expda;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Toast;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Created by Encsi on 2015.01.31..
 */


public class exTable extends ListView{
    private ObjTable obj;
    private Context context;
    private exPane pane;
    public int selectedRowIndex;

    public ArrayList<ObjTableCell> getSelectedRow() {
        return (ArrayList<ObjTableCell>)selectedRow;
    }

    public Object selectedRow;
    public exTable(Context parent, Object table, ViewGroup layout,exPane pane){
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
        if (obj.getDividerColor()!="") this.setDividerColor(obj.getDividerColor());
        this.setDividerHeight(obj.getDividerHeight());
        this.setTop(obj.getTop());
        this.setLeft(obj.getLeft());
        this.setMinimumHeight(obj.getHeight());
        this.setMinimumWidth(obj.getWidth());
        layout.addView(this, new AbsoluteLayout.LayoutParams(getObj().getWidth(), getObj().getHeight(), getObj().getLeft(), getObj().getTop()));
        this.setTag(obj.getName());
        this.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);

        final exTable lv = this;
        /*
        this.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                lv.selectedRowIndex = position;
                lv.selectedRow  = lv.getItemAtPosition(position);
//                ((LinearLayout)view).setMinimumHeight(300);
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
        */
    }

    public void setBounds(String command, int val){
        if (command.equalsIgnoreCase("SETTOP")) this.setTop1(val);
        if (command.equalsIgnoreCase("SETWIDTH")) this.setWidth1(val);
        if (command.equalsIgnoreCase("SETHEIGHT")) this.setHeight1(val);
        if (command.equalsIgnoreCase("SETLEFT")) this.setLeft1(val);
    }

    public void setDividerColor(String colorstr){
        this.getObj().setDividerColor(colorstr);
        ColorDrawable d = new ColorDrawable(Color.parseColor(colorstr));
//        d.setBounds(0,0,50,2);
        this.setDivider(d);
        //this.setDividerHeight();
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
        String[] curr = row.replace("[[", " ").trim().split("=");
        return curr;
    }

    public ArrayList<ObjTableCell>  findRow(String Mezo,String Ertek){
        exTableAdapter myAd = (exTableAdapter) this.getAdapter();
        List<Object> items = myAd.getAll();
        ArrayList<ObjTableCell> aktRow = null;
        int rowIndex = -1;
        int fieldIdx = -1;
        for (int i=0;i<items.size();i++){
            if (rowIndex==-1) {
                Object aktItem = items.get(i);
                if (fieldIdx == -1) {
                    for (int j = 0; j < ((ArrayList) aktItem).size(); j++) {
                        ObjTableCell c = (ObjTableCell) ((ArrayList) aktItem).get(j);
                        String fName = c.getName();
                        if (fName.equalsIgnoreCase(Mezo)) {fieldIdx = j;break;}
                    }
                }
                if (fieldIdx > -1) {
                    ObjTableCell c = (ObjTableCell) ((ArrayList) aktItem).get(fieldIdx);
                    String fErtek = c.getData();
                    if (rowIndex==-1 && Ertek.equalsIgnoreCase(fErtek)) {
                        rowIndex = i;
                        aktRow = (ArrayList<ObjTableCell>) aktItem;
                        break;
                    }
                }
            }
            if (rowIndex!=-1) break;
        }
        return aktRow;
    }

    public void refresh(ArrayList res){
//		tabla feltoltese
//        this.removeAll();
        ArrayList a = new ArrayList();
        exTableAdapter myAd = (exTableAdapter) this.getAdapter();

        for(int i=0;i<res.size();i++){
            String[] row = res.get(i).toString().split("]]");
            ArrayList<ObjTableCell> currentLine = new ArrayList<ObjTableCell>();
            for (int j=0;j<row.length ;j++){

                String[] temps = parseResponse(row[j]);
                int index = this.getObj().getColumnIndexByName(temps[0]);
                if (temps.length>0 && index>-1) {
                    ObjColumn col = this.getObj().getColumnByName(temps[0]);
                    String defStyle = col.getStyle();
                    int rnum = col.getRowNum();
                    String[] values;

                    String delim = "|@@";
                    String regex = "(?<!\\\\)" + Pattern.quote(delim);

                    if (temps.length>1)  values = temps[1].split(regex);
                    else values = "".split(regex);
                    String aktData = values[0];
                    String aktStyle = null;
                    if (values.length>1){
                        for (int k=1;k<values.length;k++){
                            String[] itemprops = values[k].split(":");
                            if (itemprops[0].equalsIgnoreCase("STYLE")) aktStyle = itemprops[1];
                        }
                    }
                    if (aktStyle == null) aktStyle = defStyle;
                    ObjTableCell cell = new ObjTableCell(col.getName(),aktStyle,aktData,temps[0],index,rnum);
                    currentLine.add(cell);
                }
                
            }
            a.add(currentLine);

        }
        if (myAd!=null) {
            myAd.setAll(a);
            this.setAdapter(myAd);
        }
        else {
            this.setAdapter(new exTableAdapter(context, a,getObj(),this));
        }
        //this.findRow("MIBIZ","AFE16D03946");
    }




    public ObjTable getObj() {
        return obj;
    }


    public exPane getPane() {
        return pane;
    }
}
