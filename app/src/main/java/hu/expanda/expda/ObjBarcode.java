package hu.expanda.expda;


import hu.expanda.expda.ObjDefault;
import hu.expanda.expda.exPane;

public class ObjBarcode extends ObjDefault {
	private String sqlAfterTrigger;
	private String luaAfterTrigger;
    private String extFunctionAfterTrigger;
	private String valueHolder=null;
	private Object pane;//exPane
	public ObjBarcode(){
	}
	public String getSqlAfterTrigger() {
		return sqlAfterTrigger;
	}
	public void setSqlAfterTrigger(String sqlAfterTrigger) {
		this.sqlAfterTrigger = sqlAfterTrigger;
	}
	
	public void setValueHolder(String valueHolder) {
		this.valueHolder = valueHolder;
	}
	public void setPane(exPane pane) {
		this.pane = pane;
	}
	public void valueTo(String value) {
		if (this.valueHolder!="" && this.valueHolder != null) ((exPane)pane).valueTo(valueHolder, value,false);
	}
	public String getLuaAfterTrigger() {
		return luaAfterTrigger;
	}
	public void setLuaAfterTrigger(String luaAfterTrigger) {
		this.luaAfterTrigger = luaAfterTrigger;
	}
    public String getExtFunctionAfterTrigger() {
        return extFunctionAfterTrigger;
    }

    public void setExtFunctionAfterTrigger(String extFunctionAfterTrigger) {
        this.extFunctionAfterTrigger = extFunctionAfterTrigger;
    }

	
}
