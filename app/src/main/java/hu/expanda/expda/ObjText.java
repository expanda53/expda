package hu.expanda.expda;

/**
 * Created by Encsi on 2015.02.02..
 */

public class ObjText extends ObjDefault {
    private String sqlOnExit;
    private String sqlOnChange;
    private String luaOnExit;
    private String luaOnChange;
    private String extFunctionOnExit;
    private String extFunctionOnChange;

    public String getExtFunctionOnExit() {
        return extFunctionOnExit;
    }

    public void setExtFunctionOnExit(String extFunctionOnExit) {
        this.extFunctionOnExit = extFunctionOnExit;
    }

    public String getExtFunctionOnChange() {
        return extFunctionOnChange;
    }

    public void setExtFunctionOnChange(String extFunctionOnChange) {
        this.extFunctionOnChange = extFunctionOnChange;
    }

    public String getSqlOnExit() {
        return sqlOnExit;
    }
    public void setSqlOnExit(String sqlOnExit) {
        this.sqlOnExit = sqlOnExit;
    }
    public String getSqlOnChange() {
        return sqlOnChange;
    }
    public void setSqlOnChange(String sqlOnChange) {
        this.sqlOnChange = sqlOnChange;
    }
    public String getLuaOnExit() {
        return luaOnExit;
    }
    public void setLuaOnExit(String luaOnExit) {
        this.luaOnExit = luaOnExit;
    }
    public String getLuaOnChange() {
        return luaOnChange;
    }
    public void setLuaOnChange(String luaOnChange) {
        this.luaOnChange = luaOnChange;
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
