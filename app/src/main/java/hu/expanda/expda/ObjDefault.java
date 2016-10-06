package hu.expanda.expda;

/**
 * Created by Encsi on 2015.01.29..
 */




import android.graphics.Color;
import android.view.View;

import java.lang.reflect.Array;
import java.util.ArrayList;


public class ObjDefault {
    private int Top=-99;
    private int Left=-99;
    private int Width=-99;
    private int Height=-99;
    private String Name;
    private String text="";
    private boolean visible=true;
    private int paddingTop=-1;
    private int paddingBottom=-1;
    private int paddingLeft=-1;
    private int paddingRight=-1;


    private int visibility=View.VISIBLE;
    private int foreColor = 0 ;
    private int backColor = 0;
//    private Font font;
    private String parent;
    private int FontSize=0;
    private boolean FontBold=false;
    private boolean FontItalic=false;
    private String style;
    private String borderColor="";
    private int borderWidth = -1;
    public ObjDefault(){
        parent="";
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public boolean isVisible() {
        return visible;
    }

    public void setVisible(String visible) {

        this.visible = (visible.equalsIgnoreCase("true") || visible.equalsIgnoreCase("igen") || visible=="");
        if (this.visible) setVisibility(View.VISIBLE);
        else setVisibility(View.INVISIBLE);
    }



    protected int getColor(String colorstr){
        return Color.parseColor(colorstr);

    }

    public int getForeColor() {
        return foreColor;
    }

    public void setForeColor(String foreColor) {

        this.foreColor=this.getColor(foreColor);
    }

    public int getBackColor() {
        return backColor;
    }

    public void setBackColor(String backColor) {
        this.backColor=this.getColor(backColor);

    }



    public int getTop() {
        return Top;
    }

    public void setTop(int top) {
        Top = top;
    }

    public int getLeft() {
        return Left;
    }

    public void setLeft(int left) {
        Left = left;
    }

    public int getWidth() {
        return Width;
    }

    public void setWidth(int width) {
        Width = width;
    }

    public int getHeight() {
        return Height;
    }

    public void setHeight(int height) {
        Height = height;
    }

    public String getName() {
        return Name;
    }

    public void setName(String name){
        Name=name;

    }

/*
    public Font getFont() {
        return font;
    }
*/


    public String getParent() {
        return parent;
    }

    public void setParent(String parent) {
        this.parent = parent;
    }

    public int getFontSize() {
        return FontSize;
    }

    public void setFontSize(int fontSize) {
        FontSize = fontSize;
    }

    public boolean isFontBold() {
        return FontBold;
    }

    public void setFontBold(boolean fontBold) {
        FontBold = fontBold;
    }
    public boolean isFontItalic() {
        return FontItalic;
    }

    public void setFontItalic(boolean fontItalic) {
        FontItalic = fontItalic;
    }
    public int getVisibility() {
        return visibility;
    }

    public void setVisibility(int visibility) {
        this.visibility = visibility;
    }
    public void setFontStyle(String fs){
        if (fs.toUpperCase().indexOf("BOLD")>-1) this.setFontBold(true);
        if (fs.toUpperCase().indexOf("ITALIC")>-1) this.setFontItalic(true);
    }

    public static ArrayList<ObjStyle> getObjStyle(String name){
        if (name!=null) {
            String[] styles = name.split(";");
            if (MainActivity.a_style != null && MainActivity.a_style.size() > 0) {
                ArrayList<ObjStyle> res = new ArrayList<>();
                for (String akts : styles) {
                    for (int i = 0; i < MainActivity.a_style.size(); i++) {
                        Object o = MainActivity.a_style.get(i);
                        if (((ObjStyle) o).getName().equalsIgnoreCase(akts)) {
                            res.add((ObjStyle) o);
                        }

                    }
                }
                if (res.size() > 0) return res;
                else return null;
            } else return null;
        }else return null;

    }

    public ArrayList<ObjStyle> getStyle() {
        return this.getObjStyle(this.style);
    }

    public void setStyle(String name) {
        this.style = name;
    }

    public int getPaddingRight() {
        return paddingRight;
    }

    public void setPaddingRight(int paddingRight) {
        this.paddingRight = paddingRight;
    }

    public int getPaddingTop() {
        return paddingTop;
    }

    public void setPaddingTop(int paddingTop) {
        this.paddingTop = paddingTop;
    }

    public int getPaddingBottom() {
        return paddingBottom;
    }

    public void setPaddingBottom(int paddingBottom) {
        this.paddingBottom = paddingBottom;
    }

    public int getPaddingLeft() {
        return paddingLeft;
    }

    public void setPaddingLeft(int paddingLeft) {
        this.paddingLeft = paddingLeft;
    }

    public void setBorderColor(String color){
        this.borderColor = color;
    }
    public String getBorderColor(){
        return this.borderColor;
    }
    public int getBorderWidth() {
        return borderWidth;
    }

    public void setBorderWidth(int borderWidth) {
        this.borderWidth = borderWidth;
    }

    }