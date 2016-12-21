package hu.expanda.expda;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.TextView;
import android.widget.ToggleButton;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by Encsi on 2015.01.29..
 */
public class exToggle extends ToggleButton {

    private ObjButton obj ;
    public exPane getPane() {
    return pane;
}

    private exPane pane;
    public exToggle(Context context, Object o, ViewGroup layout, exPane pane) {
        super(context);
        obj = ((ObjButton)o);
        this.pane = pane;
        this.setTextOn(getObj().getTextOn().replace("<enter>", "\n"));
        this.setTextOff(getObj().getTextOff().replace("<enter>", "\n"));
        this.setText(getObj().getText().replace("<enter>", "\n"));
        this.setChecked(getObj().isToggleChecked());
        ArrayList<ObjStyle> styles = getObj().getStyle();

        if (styles!=null){
            for (ObjStyle style : styles) {
                this.setPadding(style.getPaddingLeft(), style.getPaddingTop(), style.getPaddingRight(), style.getPaddingBottom());
                if (style.getFontSize()>0) getObj().setFontSize(style.getFontSize());
                if (style.getForeColor() != 0) this.setTextColor(style.getForeColor());
                //else this.setTextColor(Color.BLACK);
                if (style.getBackColor() != 0) this.setBackgroundColor(style.getBackColor());
                if (style.isFontBold() && style.isFontItalic()) {
                    getObj().setFontBold(true);
                    getObj().setFontItalic(true);
                }
                else if (style.isFontBold() && !style.isFontItalic()) {
                    //this.setTypeface(Typeface.SANS_SERIF, Typeface.BOLD);
                    getObj().setFontBold(true);
                    getObj().setFontItalic(false);
                }
                else if (!style.isFontBold() && style.isFontItalic()) {
                    getObj().setFontBold(false);
                    getObj().setFontItalic(true);
                    //this.setTypeface(Typeface.SANS_SERIF, Typeface.ITALIC);
                }
                if (style.getTop() != -99) getObj().setTop(style.getTop());
                if (style.getLeft() != -99) getObj().setLeft(style.getLeft());
                if (style.getHeight() != -99) getObj().setHeight(style.getHeight());
                if (style.getWidth() != -99) getObj().setWidth(style.getWidth());
            }
        }

        this.setTop(getObj().getTop());
        this.setLeft(getObj().getLeft());
        this.setWidth(getObj().getWidth());
        this.setHeight(getObj().getHeight());
        this.setVisibility(getObj().getVisibility());
        this.setGravity(getObj().getAlign());
        this.setSingleLine(false);
        if (getObj().getForeColor()!=0) this.setTextColor(getObj().getForeColor());
        if (getObj().getBackColor()!=0) this.setBackgroundColor(getObj().getBackColor());
        this.setTextSize(getObj().getFontSize());
        if (getObj().isFontBold() && getObj().isFontItalic()) this.setTypeface(null, Typeface.BOLD_ITALIC);
        else
        if (getObj().isFontBold() && !getObj().isFontItalic()) this.setTypeface(null, Typeface.BOLD);
        else
        if (!getObj().isFontBold() && getObj().isFontItalic()) this.setTypeface(null, Typeface.ITALIC);
        if (getObj().getImage()!="") {
            Drawable d = Drawable.createFromPath(getObj().getImage());
            this.setBackground(d);
        }

        this.setOnClickListener(new OnClickListener() {

            public void onClick(View v) {
                if (getPane() != null) {
                    if (((exToggle)v).isChecked()) {
                        getPane().luaInit(getObj().getLuaAfterClickToggleOn());
                        try {
                            getPane().getExtLib().runMethod(getObj().getExtFunctionAfterClickToggleOn());
                        } catch (InvocationTargetException e) {
                            e.printStackTrace();
                        } catch (IllegalAccessException e) {
                            e.printStackTrace();
                        }
                    }
                    else {
                        getPane().luaInit(getObj().getLuaAfterClickToggleOff());
                        try {
                            getPane().getExtLib().runMethod(getObj().getExtFunctionAfterClickToggleOff());
                        } catch (InvocationTargetException e) {
                            e.printStackTrace();
                        } catch (IllegalAccessException e) {
                            e.printStackTrace();
                        }

                    }
                }
//                    getPane().sendGetExecute(button.getSqlAfterClick(), true);

            }
        });
        if (layout!=null) layout.addView(this, new AbsoluteLayout.LayoutParams(getObj().getWidth(), getObj().getHeight(), getObj().getLeft(), getObj().getTop()));
        this.setTag(getObj().getName());

    }
    public void setBounds(String command, int val){
        if (command.equalsIgnoreCase("SETTOP")) this.setTop1(val);
        if (command.equalsIgnoreCase("SETWIDTH")) this.setWidth1(val);
        if (command.equalsIgnoreCase("SETHEIGHT")) this.setHeight1(val);
        if (command.equalsIgnoreCase("SETLEFT")) this.setLeft1(val);
    }

    public void setFontColor(String colorstr){
        this.getObj().setForeColor(colorstr);
        this.setTextColor(Color.parseColor(colorstr));
    }
    public void setBgColor(String colorstr){
        this.getObj().setBackColor(colorstr);
        this.setBackgroundColor(Color.parseColor(colorstr));
    }


    public void setWidth1(int width){
        getObj().setWidth(width);
        this.setWidth(getObj().getWidth());
    }
    public void setHeight1(int height){
        getObj().setHeight(height);
        this.setHeight(getObj().getHeight());
    }


    public void setTop1(int top){
        getObj().setTop(top);
        this.setTop(getObj().getTop());

    }



    public void setLeft1(int left){
        getObj().setLeft(left);
        this.setLeft(getObj().getLeft());
    }


    public ObjButton getObj() {
        return obj;
    }


}
