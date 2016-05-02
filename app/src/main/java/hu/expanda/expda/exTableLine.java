package hu.expanda.expda;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.lang.reflect.Array;
import java.util.ArrayList;

/**
 * Created by Encsi on 2015.02.23..
 */
public class exTableLine extends AbsoluteLayout {
//public class exTableLine extends LinearLayout {
    private ArrayList<TextView> a_tv = new ArrayList<TextView>();
    private ArrayList<ArrayList<TextView>> a_tv2 = new ArrayList<ArrayList<TextView>>();
    public exTableLine(Context context, Object cells){
        super(context);
//        this.setOrientation(VERTICAL);
        int e_rnum = -1;
        for (int i=0 ; i< ((ArrayList<ObjTableCell>)cells).size();i++){
            ObjTableCell cell = ((ArrayList<ObjTableCell>)cells).get(i);
            ArrayList<ObjStyle> style = cell.getStyle();
            TextView tv = new TextView(context);
            update(tv,style,cell,i);
            int rnum = cell.getRowNum();
            if (rnum!= e_rnum && e_rnum!=-1) {
                ArrayList<TextView> a = new ArrayList<>();
                a.addAll(a_tv) ;
                a_tv2.add(a);
                a_tv.clear();
            }
            a_tv.add(tv);
            e_rnum=rnum;
        }
        ArrayList<TextView> a = new ArrayList<>();
        a.addAll(a_tv);
        a_tv2.add(a);
        for (ArrayList<TextView> t : a_tv2) {
//            LinearLayout l = new LinearLayout(context);
            AbsoluteLayout l = new AbsoluteLayout(context);
            for (TextView v : t) {

                  if (v.getVisibility()==View.VISIBLE) l.addView(v, new AbsoluteLayout.LayoutParams(v.getWidth(), LayoutParams.WRAP_CONTENT,v.getLeft(),v.getTop()));
            }
            addView(l,new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
//            addView(l,new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
        }
    }
    private void update(TextView tv,ArrayList<ObjStyle> styles,ObjTableCell cell,int i){
        tv.setText(cell.getData().replace("<enter>", "\r\n"));
        tv.setSingleLine(false);
        if (styles != null) {
            exPadding p = new exPadding();
            for (ObjStyle style : styles) {
                tv.setVisibility(style.getVisibility());
                p.setValues(style,tv);
                tv.setPadding(p.getLeft(),p.getTop(),p.getRight(),p.getBottom());
                if (style.getFontSize()>0) tv.setTextSize(style.getFontSize());
                if (style.getForeColor() != -1) tv.setTextColor(style.getForeColor());
                else tv.setTextColor(Color.BLACK);
                if (style.getBackColor() != -1) tv.setBackgroundColor(style.getBackColor());
                if (style.isFontBold() && style.isFontItalic())
                    tv.setTypeface(Typeface.SANS_SERIF, Typeface.BOLD_ITALIC);
                else if (style.isFontBold() && !style.isFontItalic() )
                    tv.setTypeface(Typeface.SANS_SERIF, Typeface.BOLD);
                else if (!style.isFontBold() && style.isFontItalic())
                    tv.setTypeface(Typeface.SANS_SERIF, Typeface.ITALIC);
                if (style.getTop() != -99) tv.setTop(style.getTop());
                if (style.getLeft() != -99) tv.setLeft(style.getLeft());
                if (style.getHeight() != -99) tv.setHeight(style.getHeight());
                if (style.getWidth() != -99) tv.setWidth(style.getWidth());
            }

        } else {

            if (i > 0) {
                tv.setTextSize(13);
            } else {
                tv.setTextSize(19);
            }

            tv.setTextColor(Color.BLACK);
            tv.setTypeface(Typeface.SANS_SERIF);
        }
    }

    public void setItem(Context context, Object cells){
        int cellnum=-1;
        for (int j=0; j<getA_tv2().size();j++) {
            a_tv.clear();
            a_tv.addAll(getA_tv2().get(j));
            for (int i=0 ; i< this.a_tv.size();i++){
                cellnum++;
                ObjTableCell cell = ((ArrayList<ObjTableCell>)cells).get(cellnum);
                ArrayList<ObjStyle> style = cell.getStyle();
                update(getA_tv().get(i),style,cell,i);

            }
        }
    }

    public ArrayList<TextView> getA_tv() {
        return a_tv;
    }

    public ArrayList<ArrayList<TextView>> getA_tv2() {
        return a_tv2;
    }
}
