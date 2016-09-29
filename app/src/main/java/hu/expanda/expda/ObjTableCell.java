package hu.expanda.expda;

import java.util.ArrayList;

/**
 * Created by Encsi on 2015.02.25..
 */
public class ObjTableCell {

    public ObjTableCell (String name,String style, String data, String title,int index,int rowNum){
        setStyle(style);
        setData(data);
        setTitle(title);
        setIndex(index);
        setRowNum(rowNum);
        setName(name);

    }
    public ArrayList<ObjStyle> getStyle() {
        return ObjDefault.getObjStyle(style);
    }

    public void setStyle(String style) {
        this.style = style;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    private String style;
    private String data;
    private String title;
    private int rowNum = -1;
    private String name;

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    private int index;

    public int getRowNum() {
        return rowNum;
    }

    public void setRowNum(int rowNum) {
        this.rowNum = rowNum;
    }


    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
    }
}
