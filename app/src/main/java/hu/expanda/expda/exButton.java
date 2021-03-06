package hu.expanda.expda;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
//import android.media.Image;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by Encsi on 2015.02.02..
 */


public class exButton extends LinearLayout {
    private Context parent;
    private ObjButton button;
    private int c;
    public exPane getPane() {
        return pane;
    }

    private exPane pane;
    private ImageView iv;
    private TextView tv;
    public exButton(final Context parent,  Object o,ViewGroup layout,exPane pane) {
        super(parent);
        this.parent = parent;
        this.pane = pane;
        this.button = ((ObjButton) o);
        this.setVisibility(getObj().getVisibility());
        this.setOrientation(LinearLayout.VERTICAL);
        tv = new TextView(parent);
        tv.setText(getObj().getText());
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.CENTER_HORIZONTAL);
        this.setPadding(2, 2, 2, 2);
        //tv.setId(1);
        //RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);

        //this.setLayoutParams(lp);
        int ivId=0;
        if (this.button.getImage()!="") {
            iv = new ImageView(parent);
            iv.setImageURI(Uri.fromFile(new File(this.button.getImage())));
            tv.setGravity(Gravity.LEFT | Gravity.CENTER_VERTICAL);
            //iv.setId(2);
            LinearLayout.LayoutParams ivLP = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT,LayoutParams.MATCH_PARENT);
            ivLP.gravity = Gravity.CENTER_VERTICAL|Gravity.CENTER_HORIZONTAL;

            tv.setLayoutParams(ivLP);
            Drawable d = iv.getDrawable();
            if (getObj().getImageAlign()==Gravity.LEFT)  {
                tv.setCompoundDrawablesWithIntrinsicBounds(d, null, null, null);
                tv.setCompoundDrawablePadding(uobj.dpToPx(10));
            }
            if (getObj().getImageAlign()==Gravity.RIGHT)  {
                tv.setCompoundDrawablesWithIntrinsicBounds(null, null, d, null);
                tv.setCompoundDrawablePadding(uobj.dpToPx(10));
            }
            if (getObj().getImageAlign()==Gravity.BOTTOM)  tv.setCompoundDrawablesWithIntrinsicBounds(null, null, null, d);
            if (getObj().getImageAlign()==Gravity.TOP)  tv.setCompoundDrawablesWithIntrinsicBounds(null, d, null, null);
        }
        this.addView(tv);





        //this.setText(getObj().getText());
        int width = getObj().getWidth();
        if (width == 0) {
            width = 60;
            getObj().setWidth(width);
        }

        int height = getObj().getHeight();
        if (height == 0) {
            height = 20;
            getObj().setHeight(height);
        }

//        this.setCompoundDrawables(img,null,null,null);

        if (getObj().getForeColor() != 0)
            this.setTextColor(getObj().getForeColor());
        if (getObj().getBackColor() != 0) {
            this.setBackgroundColor(getObj().getBackColor());
            c = getObj().getBackColor();
        }



        this.setTextSize(getObj().getFontSize());
        if (getObj().isFontBold() && getObj().isFontItalic())
            this.setTypeface(null, Typeface.BOLD_ITALIC);
        else if (getObj().isFontBold() && !getObj().isFontItalic())
            this.setTypeface(null, Typeface.BOLD);
        else if (!getObj().isFontBold() && getObj().isFontItalic())
            this.setTypeface(null, Typeface.ITALIC);
        ArrayList<ObjStyle> styles = getObj().getStyle();

        if (styles!=null){
            for (ObjStyle style : styles) {
                this.setPadding(style.getPaddingLeft(), style.getPaddingTop(), style.getPaddingRight(), style.getPaddingBottom());
                if (style.getFontSize()>0) this.setTextSize(style.getFontSize());
                if (style.getForeColor() != -1) this.setTextColor(style.getForeColor());
                else this.setTextColor(Color.BLACK);
                if (style.getBackColor() != -1) {
                    this.setBackgroundColor(style.getBackColor());
                    c=style.getBackColor();
                }
                if (style.isFontBold() && style.isFontItalic())
                    this.setTypeface(Typeface.SANS_SERIF, Typeface.BOLD_ITALIC);
                else if (style.isFontBold() && !style.isFontItalic())
                    this.setTypeface(Typeface.SANS_SERIF, Typeface.BOLD);
                else if (!style.isFontBold() && style.isFontItalic())
                    this.setTypeface(Typeface.SANS_SERIF, Typeface.ITALIC);
                if (style.getTop() != -99) this.setTop(style.getTop());
                if (style.getLeft() != -99) this.setLeft(style.getLeft());
                if (style.getHeight() != -99) this.setHeight1(style.getHeight());
                if (style.getWidth() != -99) this.setWidth(style.getWidth());
                if (style.isVisibilityOverride()) this.setVisibility(style.getVisibility());
                if (style.getBorderWidth()!=-1) getObj().setBorderWidth(style.getBorderWidth());
                if (style.getBorderColor()!="") getObj().setBorderColor(style.getBorderColor());
            }
            
        }

        //border
        GradientDrawable gd = new GradientDrawable();
        gd.setColor(c); // Changes this drawbale to use a single color instead of a gradient
        gd.setCornerRadius(5);
        if (getObj().getBorderWidth()!=0) {
            gd.setStroke(getObj().getBorderWidth(), Color.parseColor(getObj().getBorderColor()));
        }
        this.setBackground(gd);
        layout.addView(this, new AbsoluteLayout.LayoutParams(getObj().getWidth(), getObj().getHeight(), getObj().getLeft(), getObj().getTop()));
//        this.name = obj.getName();
        this.setTag(getObj().getName());
//        this.addListener(SWT.Selection, infoListener);

        this.setOnClickListener(new OnClickListener() {

            public void onClick(View v) {
                if (button.getFunction().equalsIgnoreCase("CLOSE")) {
                    ((Activity) parent).finish();

                } else {

                    getPane().luaInit(button.getLuaAfterClick());
                    /*

                    try {

                       // getPane().getExtLib().runMethod(button.getExtFunctionAfterClick());
                    } catch (InvocationTargetException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    }
                    */


                }

            }
        });



    }

    public void setText(String t){
        tv.setText(t);

    }
    public void setTextColor(int c){
        tv.setTextColor(c);

    }
    public void setTextSize(int s){
        tv.setTextSize(s);

    }
    public void setHeight(int i){
        tv.setHeight(i);

    }
    public void setWidth(int i){
        tv.setWidth(i);
    }
    public void setTypeface(android.graphics.Typeface tf,int i){

        tv.setTypeface(tf, i);
    }
    public String getText(){

        return tv.getText().toString();

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
        c = getObj().getBackColor();
        //this.setBackgroundColor(Color.parseColor(colorstr));

        GradientDrawable gd = new GradientDrawable();
        gd.setColor(c); // Changes this drawbale to use a single color instead of a gradient
        gd.setCornerRadius(5);
        if (getObj().getBorderWidth()!=0) {
            gd.setStroke(getObj().getBorderWidth(), Color.parseColor(getObj().getBorderColor()));
        }
        this.setBackground(gd);
    }


    public void setWidth1(int width){
        getObj().setWidth(width);

        this.setWidth( getObj().getWidth());
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


    public ObjButton getObj(){
        return this.button;
    }





}

/*

final Button btn = new Button(this);
// Give button an ID
btn.setId(j+1);
        btn.setText("Add To Cart");
        // set the layoutParams on the button
        btn.setLayoutParams(params);

final int index = j;
        // Set click listener for button
        btn.setOnClickListener(new OnClickListener() {
public void onClick(View v) {

        Log.i("TAG", "index :" + index);

        Toast.makeText(getApplicationContext(),
        "Clicked Button Index :" + index,
        Toast.LENGTH_LONG).show();

        }
        });

        //Add button to LinearLayout
        ll.addView(btn);
        //Add button to LinearLayout defined in XML
        lm.addView(ll);
        }*/
