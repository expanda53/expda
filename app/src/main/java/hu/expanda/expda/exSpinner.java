package hu.expanda.expda;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import java.util.ArrayList;

/**
 * Created by Encsi on 2015.01.29..
 */
public class exSpinner extends Spinner {

    private ObjCombo obj ;
//    private String name;
    public exPane getPane() {
    return pane;
}

    private exPane pane;
    public exSpinner(Context context, Object o, ViewGroup layout, exPane pane) {
        super(context);
        obj = ((ObjCombo)o);
        this.pane = pane;
//        this.setText(obj.getText().replace("<enter>","\n"));
        this.setTop(obj.getTop());
        this.setLeft(obj.getLeft());
//        this.setWidth(obj.getWidth());
//        this.setHeight(obj.getHeight());
        this.setVisibility(obj.getVisibility());
//        if (obj.getForeColor()!=-1) this.setTextColor(obj.getForeColor());
        if (obj.getBackColor()!=-1) this.setBackgroundColor(obj.getBackColor());
//        this.setTextSize(obj.getFontSize());
//        if (obj.isFontBold() && obj.isFontItalic()) this.setTypeface(null, Typeface.BOLD_ITALIC);
//        else
//        if (obj.isFontBold() && !obj.isFontItalic()) this.setTypeface(null, Typeface.BOLD);
//        else
//        if (!obj.isFontBold() && obj.isFontItalic()) this.setTypeface(null, Typeface.ITALIC);
/*
        this.setOnClickListener(new OnClickListener() {

            public void onClick(View v) {

                getPane().luaInit(getObj().getLuaAfterClick());
//                    getPane().sendGetExecute(button.getSqlAfterClick(), true);

            }
        });
*/
        ArrayList<ObjStyle> styles = getObj().getStyle();

        if (styles!=null){
            for (ObjStyle style : styles) {
                this.setPadding(style.getPaddingLeft(), style.getPaddingTop(), style.getPaddingRight(), style.getPaddingBottom());
//                if (style.getFontSize()>0) this.setTextSize(style.getFontSize());
//                if (style.getForeColor() != -1) this.setTextColor(style.getForeColor());
//                else this.setTextColor(Color.BLACK);
                if (style.getBackColor() != -1) this.setBackgroundColor(style.getBackColor());
/*
                if (style.isFontBold() && style.isFontItalic())
                    this.setTypeface(Typeface.SANS_SERIF, Typeface.BOLD_ITALIC);
                else if (style.isFontBold() && !style.isFontItalic())
                    this.setTypeface(Typeface.SANS_SERIF, Typeface.BOLD);
                else if (!style.isFontBold() && style.isFontItalic())
                    this.setTypeface(Typeface.SANS_SERIF, Typeface.ITALIC);
*/
                if (style.getTop() != -99) this.setTop(style.getTop());
                if (style.getLeft() != -99) this.setLeft(style.getLeft());
/*
                if (style.getHeight() != -99) this.setHeight(style.getHeight());
                if (style.getWidth() != -99) this.setWidth(style.getWidth());
*/
            }
        }
        this.setVerticalScrollBarEnabled(true);
        layout.addView(this, new AbsoluteLayout.LayoutParams(obj.getWidth(), obj.getHeight(), obj.getLeft(), obj.getTop()));
        this.setTag(obj.getName());
    }
    public void setBounds(String command, int val){
        if (command.equalsIgnoreCase("SETTOP")) this.setTop1(val);
        if (command.equalsIgnoreCase("SETWIDTH")) this.setWidth1(val);
        if (command.equalsIgnoreCase("SETHEIGHT")) this.setHeight1(val);
        if (command.equalsIgnoreCase("SETLEFT")) this.setLeft1(val);
    }

    public void setFontColor(String colorstr){
        this.getObj().setForeColor(colorstr);
//        this.setTextColor(Color.parseColor(colorstr));
    }
    public void setBgColor(String colorstr){
        this.getObj().setBackColor(colorstr);
        this.setBackgroundColor(Color.parseColor(colorstr));
    }


    public void setWidth1(int width){
        getObj().setWidth(width);
//        this.setWidth(getObj().getWidth());
    }
    public void setHeight1(int height){
        getObj().setHeight(height);
//        this.setHeight(getObj().getHeight());
    }


    public void setTop1(int top){
        getObj().setTop(top);
        this.setTop(getObj().getTop());

    }



    public void setLeft1(int left){
        getObj().setLeft(left);
        this.setLeft(getObj().getLeft());
    }


    public ObjCombo getObj() {
        return obj;
    }

    public void setItems(String itemsString, String delimiter){
        String[] items = itemsString.split(delimiter);
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(pane.getContext(), android.R.layout.simple_spinner_item,items);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        this.setAdapter(adapter);
    }


}
