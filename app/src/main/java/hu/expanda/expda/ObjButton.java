package hu.expanda.expda;

import android.graphics.Color;
import android.view.Gravity;

/**
 * Created by Encsi on 2015.02.02..
 */
public class ObjButton extends ObjDefault{
    private String Function;
    private String extFunctionAfterClick;
    private String SqlAfterClick;
    private String LuaAfterClick;
    private String LuaAfterClickToggleOn;
    private String LuaAfterClickToggleOff;
    private String extFunctionAfterClickToggleOn;
    private String extFunctionAfterClickToggleOff;
    private String Image="";
    private int align=Gravity.CENTER; //swt.center
    private int imageAlign=Gravity.LEFT; //swt.center
    private String toggleTextOn="On";
    private String toggleTextOff="Off";
    private boolean toggleChecked = true;

    public int getAlign() {
            return align;
        }

    public void setAlign(String align) {
            if (align.equalsIgnoreCase("CENTER")) this.align = Gravity.CENTER;//SWT.CENTER;
            if (align.equalsIgnoreCase("LEFT")) this.align = Gravity.LEFT;//SWT.LEFT;
            if (align.equalsIgnoreCase("RIGHT")) this.align = Gravity.RIGHT;//SWT.RIGHT;
    }

    public int getImageAlign() {
        return imageAlign;
    }

    public void setImageAlign(String imageAlign) {
        if (imageAlign.equalsIgnoreCase("LEFT")) this.imageAlign = Gravity.LEFT;//SWT.LEFT;
        if (imageAlign.equalsIgnoreCase("RIGHT")) this.imageAlign = Gravity.RIGHT;//SWT.RIGHT;
        if (imageAlign.equalsIgnoreCase("TOP")) this.imageAlign = Gravity.TOP;//SWT.CENTER;
        if (imageAlign.equalsIgnoreCase("BOTTOM")) this.imageAlign = Gravity.BOTTOM;//SWT.CENTER;
    }

    public String getFunction() {
        return Function;
    }

    public void setFunction(String type) {
        this.Function = type;
    }
    public String getExtFunctionAfterClick() {
        return extFunctionAfterClick;
    }

    public void setExtFunctionAfterClick(String type) {
        this.extFunctionAfterClick = type;
    }

    public String getExtFunctionAfterClickToggleOn() {
        return extFunctionAfterClickToggleOn;
    }

    public void setExtFunctionAfterClickToggleOn(String type) {
        this.extFunctionAfterClickToggleOn = type;
    }
    public String getExtFunctionAfterClickToggleOff() {
        return extFunctionAfterClickToggleOff;
    }

    public void setExtFunctionAfterClickToggleOff(String type) {
        this.extFunctionAfterClickToggleOff = type;
    }
    public String getSqlAfterClick() {
        return SqlAfterClick;
    }
    public void setSqlAfterClick(String sqlAfterClick) {
        this.SqlAfterClick = sqlAfterClick;
    }

    public String getImage() {
        if (Image!="")	return Ini.getImgDir()+"/"+Image;
        else return "";
    }

    public void setImage(String image) {
        Image = image;
    }

    public String getLuaAfterClick() {
        return LuaAfterClick;
    }

    public void setLuaAfterClick(String luaAfterClick) {
        this.LuaAfterClick = luaAfterClick;
    }

    public String getLuaAfterClickToggleOn() {
        return LuaAfterClickToggleOn;
    }

    public void setLuaAfterClickToggleOn(String luaAfterClickToggleOn) {
        this.LuaAfterClickToggleOn = luaAfterClickToggleOn;
    }
    public String getLuaAfterClickToggleOff() {
        return LuaAfterClickToggleOff;
    }

    public void setLuaAfterClickToggleOff(String luaAfterClickToggleOff) {
        this.LuaAfterClickToggleOff = luaAfterClickToggleOff;
    }
    @Override
    public int getFontSize(){
        int fsize = super.getFontSize();
        if (fsize == 0) {
            fsize=9;
        }
        return fsize;
    }

    public String getTextOn() {
        return toggleTextOn;
    }

    public void setTextOn(String textOn) {
        this.toggleTextOn = textOn;
    }

    public String getTextOff() {
        return toggleTextOff;
    }

    public void setTextOff(String textOff) {
        this.toggleTextOff = textOff;
    }

    public boolean isToggleChecked() {
        return toggleChecked;
    }

    public void setToggleChecked(boolean toggleChecked) {
        this.toggleChecked = toggleChecked;
    }
}
