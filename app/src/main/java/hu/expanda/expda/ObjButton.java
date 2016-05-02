package hu.expanda.expda;

/**
 * Created by Encsi on 2015.02.02..
 */
public class ObjButton extends ObjDefault{
    private String Function;
    private String extFunctionAfterClick;
    private String SqlAfterClick;
    private String LuaAfterClick;
    private String Image="";
        private int align=0; //swt.center

        public int getAlign() {
            return align;
        }

        public void setAlign(String align) {
            if (align.equalsIgnoreCase("CENTER")) this.align = 0;//SWT.CENTER;
            if (align.equalsIgnoreCase("LEFT")) this.align = 1;//SWT.LEFT;
            if (align.equalsIgnoreCase("RIGHT")) this.align = 2;//SWT.RIGHT;
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

    public String getSqlAfterClick() {
        return SqlAfterClick;
    }



    public void setSqlAfterClick(String sqlAfterClick) {
        this.SqlAfterClick = sqlAfterClick;
    }

    public String getImage() {
//        if (Image!="")	return Ini.getImgDir()+"\\"+Image;
//        else return "";
        return "";
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






}
