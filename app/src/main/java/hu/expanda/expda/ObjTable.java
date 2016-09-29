package hu.expanda.expda;

import java.util.ArrayList;




public class ObjTable extends ObjDefault {
	private String sqlOnCreate;
	private String sqlAfterClick;
	private String luaOnCreate;
	private String luaAfterClick;
	private String extFunctionOnCreate;
	private String extFunctionAfterClick;
	private String itemPanel = "";
	private ArrayList<ObjColumn> columns;
	private String[] valueFrom;
	private String[] valueTo;
	private int rowHeight;
    private String viewType = "List";
    private String dividerColor="";
    private int dividerHeight=1;
    public ObjTable(String vt){
        setText("...");
        //columns = new ObjColumn[10];
        columns = new ArrayList();
        this.setViewType(vt);
    }
	public String getsqlOnCreate() {
		return sqlOnCreate;
	}

	public void setSqlOnCreate(String sqlOnCreate) {
		this.sqlOnCreate = sqlOnCreate;
	}
	public String[] getTitles() {
		String res = "";
			for (int i=0;i<columns.size();i++){
				
				 res += ((ObjColumn)columns.get(i)).getTitle()+";";
				
			}
			return res.split(";") ;
	
	}
	
	public int getColumnIndexByName(String name){
		int res = -1;
		if ((columns==null) || (columns.size()==0)) return res;
		else {
			for (int i=0;i<columns.size();i++){
				
				if (((ObjColumn)columns.get(i)).getName().equalsIgnoreCase(name)){
					res=i;
				}
			}
			return res;
		}
	}
	
	public ObjColumn getColumnByName(String name){
		ObjColumn res = null;
		if ((columns==null) || (columns.size()==0)) return res;
		else {
			for (int i=0;i<columns.size();i++){
				
				if (((ObjColumn)columns.get(i)).getName().equalsIgnoreCase(name)){
					res=(ObjColumn)columns.get(i);
				}
			}
			return res;
		}
	}
	
	public void setColumn(String property, String value){
		String[] prop = property.split( "_");
		String aktprop = prop[1];
		String colname=prop[2];
		int colIndex = this.getColumnIndexByName(colname);
		if (colIndex==-1) {
			ObjColumn col = new ObjColumn();
			col.setName(colname);
			colIndex=columns.size();
			columns.add(col);
		}
		ObjColumn col = this.getColumnByName(colname);
		if (aktprop.equalsIgnoreCase("width")) col.setWidth(  Integer.parseInt(value));
		if (aktprop.equalsIgnoreCase("title")) col.setTitle(value);
        if (aktprop.equalsIgnoreCase("rownum")) col.setRowNum(Integer.parseInt(value));
		if (aktprop.equalsIgnoreCase("style")) col.setStyle(value);
		columns.set(colIndex, col);
//		System.out.println(property+" "+value);
	}
	
	public Object[] getColumns(){
		return columns.toArray();
	}
	public String[] getValueTo() {
		return valueTo;
	}
	public void setValueTo(String valueTo) {
		this.valueTo = valueTo.split(";");
	}
	public String[] getValueFrom() {
		return valueFrom;
	}
	public void setValueFrom(String valueFrom) {
		this.valueFrom = valueFrom.split(";");
	}
	public String getSqlAfterClick() {
		return sqlAfterClick;
	}
	public void setSqlAfterClick(String sqlAfterClick) {
		this.sqlAfterClick = sqlAfterClick;
	}
	public String getLuaOnCreate() {
		return luaOnCreate;
	}
	public void setLuaOnCreate(String luaOnCreate) {
		this.luaOnCreate = luaOnCreate;
	}
	public String getLuaAfterClick() {
		return luaAfterClick;
	}
	public void setLuaAfterClick(String luaAfterClick) {
		this.luaAfterClick = luaAfterClick;
	}
	public int getRowHeight() {
		return rowHeight;
	}
	public void setRowHeight(int rowHeight) {
		this.rowHeight = rowHeight;
	}
    public String getViewType() {
        return viewType;
    }

    public void setViewType(String viewType) {
        this.viewType = viewType;
    }

    public String getDividerColor() {
        return dividerColor;
    }

    public void setDividerColor(String dividerColor) {
        this.dividerColor = dividerColor;
    }
    @Override
    public int getFontSize(){
        int fsize = super.getFontSize();
        if (fsize == 0) {
            fsize=9;
        }
        return fsize;
    }
	public String getExtFunctionOnCreate() {        return extFunctionOnCreate;    }
	public void setExtFunctionOnCreate(String extFunctionOnCreate) {        this.extFunctionOnCreate = extFunctionOnCreate;    }

	public String getExtFunctionAfterClick() {        return extFunctionAfterClick;    }
	public void setExtFunctionAfterClick(String extFunctionOnCreate) {        this.extFunctionAfterClick = extFunctionAfterClick;    }

	public String getItemPanel() {
		return itemPanel;
	}

	public void setItemPanel(String itemPanel) {
		this.itemPanel = itemPanel;
	}

    public int getDividerHeight() {
        return dividerHeight;
    }

    public void setDividerHeight(int dividerHeight) {
        this.dividerHeight = dividerHeight;
    }
}
