package hu.expanda.expda;

import android.net.Uri;

/**
 * Created by Encsi on 2015.01.29..
 */



    public class ObjCombo extends ObjDefault {
        private String LuaAfterClick="";
        private String LuaOnCreate="";
        private String Items="";

    public String getLuaAfterClick() {
        return LuaAfterClick;
    }
    public void setLuaAfterClick(String luaAfterClick) {
        LuaAfterClick = luaAfterClick;
    }

    public String getLuaOnCreate() {
        return LuaOnCreate;
    }
    public void setLuaOnCreate(String luaOnCreate) {
        LuaOnCreate = luaOnCreate;
    }




    @Override
    public int getFontSize(){
        int fsize = super.getFontSize();
        if (fsize == 0) {
            fsize=9;
        }
        return fsize;
    }

    public String getItems() {
        return Items;
    }

    public void setItems(String items) {
        Items = items;
    }
}

