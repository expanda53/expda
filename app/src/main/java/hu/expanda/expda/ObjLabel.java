package hu.expanda.expda;

import android.net.Uri;
import android.view.Gravity;

/**
 * Created by Encsi on 2015.01.29..
 */



    public class ObjLabel extends ObjDefault {
        private int align=Gravity.LEFT; //swt.center
        private String Image="";
        private String LuaAfterClick="";


    private String extFunctionAfterClick="";
        public int getAlign() {
            return align;
        }
        private int maxLines = 15;

        public void setAlign(String align) {
            if (align.equalsIgnoreCase("CENTER")) this.align = Gravity.CENTER;//SWT.CENTER;
            if (align.equalsIgnoreCase("LEFT")) this.align = Gravity.LEFT;//SWT.LEFT;
            if (align.equalsIgnoreCase("RIGHT")) this.align = Gravity.RIGHT;//SWT.RIGHT;
        }
        public String getImage() {
            if (Image!="")	{
                Uri uri = Uri.parse(Ini.getImgDir()+"/"+Image);
                return uri.getPath();
            }
            else return "";

        }

        public void setImage(String image) {
            Image = image;
        }
    public String getLuaAfterClick() {
        return LuaAfterClick;
    }

    public void setLuaAfterClick(String luaAfterClick) {
        LuaAfterClick = luaAfterClick;
    }
    @Override
    public int getFontSize(){
        int fsize = super.getFontSize();
        if (fsize == 0) {
            fsize=9;
        }
        return fsize;
    }

    public int getMaxLines() {
        return maxLines;
    }

    public void setMaxLines(int maxLines) {
        this.maxLines = maxLines;
    }
    public String getExtFunctionAfterClick() {
        return extFunctionAfterClick;
    }

    public void setExtFunctionAfterClick(String extFunctionAfterClick) {
        this.extFunctionAfterClick = extFunctionAfterClick;
    }

}

