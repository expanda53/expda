package hu.expanda.expda;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.GridLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.lang.reflect.Array;
import java.util.ArrayList;

/**
 * Created by Encsi on 2015.02.23..
 */
//public class exTableLine extends AbsoluteLayout {
public class exTableLine extends LinearLayout {
    private ArrayList<TextView> a_tv = new ArrayList<TextView>();
    private ArrayList<ArrayList<TextView>> a_tv2 = new ArrayList<ArrayList<TextView>>();
    private ObjTable obj;
    private exPanel masterPanel = null;
    private exTable eTable = null;
    private Context c;
    private exPane pane;
    private Object cells;
    public exTableLine(Context context, Object cells,ObjTable obj,exTable eTable){
        super(context);
        this.obj = obj;
        this.cells=cells;
        this.setOrientation(VERTICAL);
        this.eTable = eTable;
        this.c=context;
        this.pane = eTable.getPane();
        Object o = pane.findObject(obj.getItemPanel());
        if (o  instanceof  exPanel) masterPanel = (exPanel)o;
        if (masterPanel != null) {
            updatePanel(cells);
        }
        else {
            int e_rnum = -1;
            for (int i = 0; i < ((ArrayList<ObjTableCell>) cells).size(); i++) {
                ObjTableCell cell = ((ArrayList<ObjTableCell>) cells).get(i);
                ArrayList<ObjStyle> style = cell.getStyle();
                TextView tv = new TextView(context);
                update(tv, style, cell, i);
                int rnum = cell.getRowNum();
                if (rnum != e_rnum && e_rnum != -1) {
                    ArrayList<TextView> a = new ArrayList<>();
                    a.addAll(a_tv);
                    a_tv2.add(a);
                    a_tv.clear();
                }
                a_tv.add(tv);
                e_rnum = rnum;
            }
            ArrayList<TextView> a = new ArrayList<>();
            a.addAll(a_tv);
            a_tv2.add(a);
            for (ArrayList<TextView> t : a_tv2) {
                LinearLayout l = new LinearLayout(context);
//            AbsoluteLayout l = new AbsoluteLayout(context);
                for (TextView v : t) {

                    if (v.getVisibility() == View.VISIBLE) {
                        //l.addView(v, new AbsoluteLayout.LayoutParams(v.getMinWidth(), LayoutParams.WRAP_CONTENT,v.getLeft(),v.getTop()));
                        //l.addView(v, new LinearLayout.LayoutParams(/*v.getMinWidth()*/LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
                        l.addView(v);
                    }
                }
//            addView(l,new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));

                addView(l, new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
            }
        }
    }

    private void updatePanel(Object cells){
        exPanel p = new exPanel(c,masterPanel.getObj(), null,this.pane);

        p.setWidth1(masterPanel.getMinimumWidth());
        //p.setHeight1(masterPanel.getMinimumHeight());

        p.setMinimumHeight(masterPanel.getHeight());
        //p.setMinimumWidth(masterPanel.getWidth());
        p.setBackgroundColor(masterPanel.getObj().getBackColor());
        p.setVisibility(View.VISIBLE);
        p.setOnClickListener(null);
        p.setClickable(false);
        p.setFocusable(false);
        p.setTag('_'+masterPanel.getObj().getName());
        for (int i = 0; i < masterPanel.getChildCount(); i++) {
            View aktView = masterPanel.getChildAt(i);
            if (aktView instanceof exTextView) {
                String akttext = ((exTextView)aktView).getText().toString();
                if (akttext.indexOf("[")==-1) {
                    exTextView tv = new exTextView(p.getContext(),((exTextView) aktView).getObj(), null, pane);
                    //tv.setText(cell.getData());
                    tv.setTop(tv.getObj().getTop());
                    tv.setLeft(tv.getObj().getLeft());
                    tv.setWidth(tv.getObj().getWidth());
                    tv.setMinimumWidth(tv.getObj().getWidth());
                    tv.setHeight(tv.getObj().getHeight());
                    tv.setMinimumHeight(tv.getObj().getHeight());
                    tv.setBackgroundColor(tv.getObj().getBackColor());
                    tv.setTextColor(tv.getObj().getForeColor());
                    tv.setTextSize(tv.getObj().getFontSize());
                    tv.setVisibility(tv.getObj().getVisibility());
                    //tv.setClickable(false);
                    tv.setFocusable(false);
                    tv.setTag('_' + tv.getObj().getName());
                    p.addView(tv, new AbsoluteLayout.LayoutParams(tv.getMinimumWidth(), tv.getMinimumHeight(), tv.getLeft(), tv.getTop()));


                }
            }
            else p.addView(aktView);
        }
        for (int i = 0; i < ((ArrayList<ObjTableCell>) cells).size(); i++) {
            ObjTableCell cell = ((ArrayList<ObjTableCell>) cells).get(i);
            ArrayList<ObjStyle> style = cell.getStyle();
            View v = pane.findObject(cell.getName());
            v.setOnClickListener(null);
            if (v instanceof exTextView) {
                exTextView tv = new exTextView(p.getContext(),((exTextView) v).getObj(), null, pane);
                //tv.setText(cell.getData());
                tv.setTop(tv.getObj().getTop());
                tv.setLeft(tv.getObj().getLeft());
                tv.setWidth(tv.getObj().getWidth());
                tv.setMinimumWidth(tv.getObj().getWidth());
                tv.setHeight(tv.getObj().getHeight());
                tv.setMinimumHeight(tv.getObj().getHeight());
                tv.setBackgroundColor(tv.getObj().getBackColor());
                tv.setTextColor(tv.getObj().getForeColor());
                tv.setTextSize(tv.getObj().getFontSize());
                tv.setVisibility(tv.getObj().getVisibility());
                tv.setOnClickListener(null);

                //tv.setClickable(false);
                tv.setFocusable(false);
                update(tv, style, cell, i);
                tv.setTag('_' + tv.getObj().getName());
                p.addView(tv , new AbsoluteLayout.LayoutParams(tv.getMinimumWidth(), tv.getMinimumHeight(), tv.getLeft(), tv.getTop()));
            }

        }
        addView(p, new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));

    }
    private void update(TextView tv,ArrayList<ObjStyle> styles, ObjTableCell cell, int i) {
        tv.setText(cell.getData().replace("<enter>", "\r\n"));
        tv.setSingleLine(false);

        if (styles != null) {
            exPadding p = new exPadding();
            for (ObjStyle style : styles) {
                tv.setVisibility(style.getVisibility());
                p.setValues(style, tv);
                tv.setPadding(p.getLeft(),p.getTop(),p.getRight(),p.getBottom());
                if (style.getFontSize()>0) tv.setTextSize(style.getFontSize());
                if (style.getForeColor() != -1) tv.setTextColor(style.getForeColor());
                //else tv.setTextColor(Color.BLACK);
                if (style.getBackColor() != -1) tv.setBackgroundColor(style.getBackColor());
                if (style.isFontBold() && style.isFontItalic())
                    tv.setTypeface(Typeface.SANS_SERIF, Typeface.BOLD_ITALIC);
                else if (style.isFontBold() && !style.isFontItalic() )
                    tv.setTypeface(Typeface.SANS_SERIF, Typeface.BOLD);
                else if (!style.isFontBold() && style.isFontItalic())
                    tv.setTypeface(Typeface.SANS_SERIF, Typeface.ITALIC);
               /*
                if (style.getTop() != -99) tv.setTop(style.getTop());
                if (style.getLeft() != -99) tv.setLeft(style.getLeft());
                if (style.getHeight() != -99) tv.setHeight(style.getHeight());
                if (style.getWidth() != -99) tv.setWidth(style.getWidth());
                */

            }

        } else {

            if (i > 0) {
                tv.setTextSize(13);
            } else {
                tv.setTextSize(19);
            }

             tv.setWidth(200);
            tv.setHeight(50);

            tv.setTextColor(obj.getForeColor());
            tv.setBackgroundColor(obj.getBackColor());
            tv.setTypeface(Typeface.SANS_SERIF);
            tv.setVisibility(exTextView.VISIBLE);
        }
    }

    public void setItem(Context context, Object cells){
        int cellnum=-1;
        if (getA_tv2().size()>0) {
            for (int j = 0; j < getA_tv2().size(); j++) {
                a_tv.clear();
                a_tv.addAll(getA_tv2().get(j));
                for (int i = 0; i < this.a_tv.size(); i++) {
                    cellnum++;
                    ObjTableCell cell = ((ArrayList<ObjTableCell>) cells).get(cellnum);
                    ArrayList<ObjStyle> style = cell.getStyle();
                    update(getA_tv().get(i), style, cell, i);

                }
            }
        }
        else {
            for (int i = 0; i < ((ArrayList<ObjTableCell>) cells).size(); i++) {
                ObjTableCell cell = ((ArrayList<ObjTableCell>) cells).get(i);
                ArrayList<ObjStyle> style = cell.getStyle();
                //View v = pane.findObject('_' + cell.getName());
                View v = this.findViewWithTag('_'+cell.getName());
                if (v == null) {
                    updatePanel(cells); /* ha vmiért nem jött létre korábban a panel és a rajta lévő textview-k, most létrehozza */
                    v = (exTextView)this.findViewWithTag('_'+cell.getName());
                }

                update((exTextView)v,style,cell,i);
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
