package hu.expanda.expda;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.LinearLayout;

import java.lang.reflect.InvocationTargetException;

/**
 * Created by Encsi on 2015.01.31..
 */


public class exPanel extends AbsoluteLayout{
    private ObjPanel obj;
    private exPane pane;
    public exPanel(Context parent, Object panel,ViewGroup layout,exPane pane){
        super(parent);
        this.setPane(pane);
        this.obj=(ObjPanel)panel;
        this.setVisibility(obj.getVisibility());
        if (this.getVisibility()== exTextView.VISIBLE) this.bringToFront();
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
        this.setVerticalScrollBarEnabled(true);
        if (layout!=null) layout.addView(this, new AbsoluteLayout.LayoutParams(obj.getWidth(), obj.getHeight(), obj.getLeft(), obj.getTop()) );
        this.setTag(obj.getName());

//		System.out.println(this.getData("NAME"));

        getPane().luaInit(getObj().getLuaOnCreate());
        try {
            getPane().getExtLib().runMethod(getObj().getExtFunctionOnCreate());
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

    }

    public exPane getPane() {
        return pane;
    }

    public void setPane(exPane pane) {
        this.pane = pane;
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



    public ObjPanel getObj() {
        return obj;
    }


}
