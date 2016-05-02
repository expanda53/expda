package hu.expanda.expda;

/**
 * Created by Encsi on 2015.01.31..
 */




public class ObjPanel extends ObjDefault {
    private String sqlOnCreate;
    private String luaOnCreate;
    private String extFunctionOnCreate;
    private boolean mainPanel;
    private boolean taskPanel;
    private boolean menuPanel;
    private String[] ParamsToLabels;
    public ObjPanel(boolean mainParent, boolean taskPanel, boolean menuPanel){
        setMainPanel(mainParent);
        setTaskPanel(taskPanel);
        setMenuPanel(menuPanel);
        setText("...");
    }
    public String getsqlOnCreate() {
        return sqlOnCreate;
    }

    public void setSqlOnCreate(String sqlOnCreate) {
        this.sqlOnCreate = sqlOnCreate;
    }
    public boolean isMainPanel() {
        return mainPanel;
    }
    public void setMainPanel(boolean mainParent) {
        this.mainPanel = mainParent;
    }
    public boolean isTaskPanel() {
        return taskPanel;
    }
    public void setTaskPanel(boolean taskPanel) {
        this.taskPanel = taskPanel;
    }
    public boolean isMenuPanel() {
        return menuPanel;
    }
    public void setMenuPanel(boolean menuPanel) {
        this.menuPanel = menuPanel;
    }
    public String[] getParamsToLabels() {
        return ParamsToLabels;
    }
    public void setParamsToLabels(String paramsToLabels) {
        ParamsToLabels = paramsToLabels.split(";");
    }
    public String getLuaOnCreate() {
        return luaOnCreate;
    }
    public void setLuaOnCreate(String luaOnCreate) {
        this.luaOnCreate = luaOnCreate;
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


}

