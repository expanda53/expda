package hu.expanda.expda;

import android.app.ActionBar;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.widget.AbsoluteLayout;

import java.util.ArrayList;

/**
 * Created by Encsi on 2015.01.29..
 */
public class uobj {

        private ArrayList<String> items = new ArrayList<>();
        private String name;
        public uobj(String name, ArrayList<String> props){
            this.items=props;
            this.name=name;
        }
        public static int dpToPx(int dp) {
            return  (int)(MainActivity.dmetrics.density * dp);
            //int height = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, metrics);
            //return  height;
        }

        private Object setClass(){

            Object aktobj=null;
            for (int i=0;i<items.size();i++){
                String line = items.get(i).toString();
                if (line.toUpperCase().indexOf("TYPE=")==0) {
                    String res[] = line.split("=");
                    if (res.length>1){
                        String type = res[1];
                        if (type.equalsIgnoreCase("label")) aktobj = new ObjLabel();
                        if (type.equalsIgnoreCase("panel")) aktobj = new ObjPanel(false,false,false);
                        if (type.equalsIgnoreCase("imgbutton")) {
                            aktobj = new ObjButton();
                            ((ObjButton)aktobj).setFunction("custom");
                        }
                        if (type.equalsIgnoreCase("custom_button")) {
                            aktobj = new ObjButton();
                            ((ObjButton)aktobj).setFunction("custom");
                        }
                        if (type.equalsIgnoreCase("print_button")) {
                            aktobj = new ObjButton();
                            ((ObjButton)aktobj).setFunction("print");
                        }
                        if (type.equalsIgnoreCase("toggle_button")) {
                            aktobj = new ObjButton();
                            ((ObjButton)aktobj).setFunction("toggle");
                        }
                        if (type.equalsIgnoreCase("edit") || type.equalsIgnoreCase("text")) aktobj = new ObjText();
                        if (type.equalsIgnoreCase("barcode")) aktobj = new ObjBarcode();
                        if (type.equalsIgnoreCase("panel")) aktobj = new ObjPanel(false,false,false);
                        if (type.equalsIgnoreCase("mainpanel")) aktobj = new ObjPanel(true,false,false);
                        if (type.equalsIgnoreCase("taskpanel")) aktobj = new ObjPanel(true,true,false);
                        if (type.equalsIgnoreCase("menupanel")) aktobj = new ObjPanel(true,false,true);
                        if (type.equalsIgnoreCase("table"))     aktobj = new ObjTable("list");
                        if (type.equalsIgnoreCase("list"))     aktobj = new ObjTable("list");
                        if (type.equalsIgnoreCase("grid"))      aktobj = new ObjTable("grid");
                        if (type.equalsIgnoreCase("style")) aktobj = new ObjStyle();
                    }
                }
            }
            return aktobj;
        }

        private Object setProperties(){
            Object obj =  setClass();
            if (obj!=null){
                if (obj instanceof ObjDefault) ((ObjDefault)obj).setName(name);
                for (int i=0;i<items.size();i++){
                    String line = items.get(i).toString();
                    String[] aktrow = line.split("=");
                    String property = aktrow[0];
                    String value = aktrow[1];
//				System.out.println("prop:"+property+" val:"+value);
                    if (property.equalsIgnoreCase("height")) {
                        if (value.equalsIgnoreCase("FILL")) ((ObjDefault) obj).setHeight(AbsoluteLayout.LayoutParams.FILL_PARENT);
                        else if (value.equalsIgnoreCase("WRAP")) ((ObjDefault) obj).setHeight(AbsoluteLayout.LayoutParams.WRAP_CONTENT);
                        else if (value.equalsIgnoreCase("MATCH")) ((ObjDefault) obj).setHeight(AbsoluteLayout.LayoutParams.MATCH_PARENT);
                        else ((ObjDefault) obj).setHeight(Integer.parseInt(value));
                    }
                    else
                    if (property.equalsIgnoreCase("width")) {
                        if (value.equalsIgnoreCase("FILL")) ((ObjDefault) obj).setWidth(AbsoluteLayout.LayoutParams.FILL_PARENT);
                        else if (value.equalsIgnoreCase("WRAP")) ((ObjDefault) obj).setWidth(AbsoluteLayout.LayoutParams.WRAP_CONTENT);
                        else if (value.equalsIgnoreCase("MATCH")) ((ObjDefault) obj).setWidth(AbsoluteLayout.LayoutParams.MATCH_PARENT);
                        else ((ObjDefault)obj).setWidth(Integer.parseInt(value));
                    }
                    else
                    if (property.equalsIgnoreCase("top")) ((ObjDefault)obj).setTop(Integer.parseInt(value));
                    else
                    if (property.equalsIgnoreCase("left")) ((ObjDefault)obj).setLeft(Integer.parseInt(value));
                    else
                    if (property.equalsIgnoreCase("text")) ((ObjDefault)obj).setText(value);
                    else
                    if (property.equalsIgnoreCase("visible")) {
                        ((ObjDefault)obj).setVisible(value);
                        if (obj instanceof ObjStyle) {
                            ((ObjStyle)obj).setVisibilityOverride(true);
                        }
                    }
                    else
                    if (property.equalsIgnoreCase("font_color")) {
                        ((ObjDefault)obj).setForeColor(value);
                    }
                    else
                    if (property.equalsIgnoreCase("bgcolor")) ((ObjDefault)obj).setBackColor(value);
                    else
                    if (property.equalsIgnoreCase("font_size")) ((ObjDefault)obj).setFontSize(Integer.parseInt(value));
                    else
                    if (property.equalsIgnoreCase("font_style")) ((ObjDefault)obj).setFontStyle(value);
                    else
                    if (property.equalsIgnoreCase("font_italic")) ((ObjDefault)obj).setFontItalic(value.equalsIgnoreCase("font_italic"));
                    else
                    if (property.equalsIgnoreCase("style"))      ((ObjDefault)obj).setStyle(value);
                    else
                    if (property.equalsIgnoreCase("padding_top")) ((ObjDefault)obj).setPaddingTop(Integer.parseInt(value));
                    else
                    if (property.equalsIgnoreCase("padding_left")) ((ObjDefault)obj).setPaddingLeft(Integer.parseInt(value));
                    else
                    if (property.equalsIgnoreCase("padding_right")) ((ObjDefault)obj).setPaddingRight(Integer.parseInt(value));
                    else
                    if (property.equalsIgnoreCase("padding_bottom")) ((ObjDefault)obj).setPaddingBottom(Integer.parseInt(value));
                    else
                    if (property.equalsIgnoreCase("parent")) ((ObjDefault)obj).setParent(value);
                    else
                    if (property.equalsIgnoreCase("border_width")) ((ObjDefault)obj).setBorderWidth(Integer.parseInt(value));
                    else
                    if (property.equalsIgnoreCase("border_color")) ((ObjDefault)obj).setBorderColor(value);

                    if (obj instanceof ObjButton) {
                        if (property.equalsIgnoreCase("sql_after_click")) ((ObjButton)obj).setSqlAfterClick(value);
                        if (property.equalsIgnoreCase("lua_after_click")) ((ObjButton)obj).setLuaAfterClick(value);
                        if (property.equalsIgnoreCase("lua_after_on_click")) ((ObjButton)obj).setLuaAfterClickToggleOn(value);
                        if (property.equalsIgnoreCase("lua_after_off_click")) ((ObjButton)obj).setLuaAfterClickToggleOff(value);
                        if (property.equalsIgnoreCase("text_on")) ((ObjButton)obj).setTextOn(value);
                        if (property.equalsIgnoreCase("text_off")) ((ObjButton)obj).setTextOff(value);
                        if (property.equalsIgnoreCase("checked")) ((ObjButton)obj).setToggleChecked(value.equalsIgnoreCase("true"));
                        //if (property.equalsIgnoreCase("border_width")) ((ObjButton)obj).setBorderWidth(Integer.parseInt(value));
                        //if (property.equalsIgnoreCase("border_color")) ((ObjButton)obj).setBorderColor(value);
                        if (property.equalsIgnoreCase("extfunction_after_click"))  ((ObjButton)obj).setExtFunctionAfterClick(value);
                        if (property.equalsIgnoreCase("extfunction_after_on_click"))  ((ObjButton)obj).setExtFunctionAfterClickToggleOn(value);
                        if (property.equalsIgnoreCase("extfunction_after_off_click"))  ((ObjButton)obj).setExtFunctionAfterClickToggleOff(value);
                        if (property.equalsIgnoreCase("function")) ((ObjButton)obj).setFunction(value);
                        if (property.equalsIgnoreCase("image")) ((ObjButton)obj).setImage(value);
                        if (property.equalsIgnoreCase("image_align")) ((ObjButton)obj).setImageAlign(value);
                    }
                    if (obj instanceof ObjPanel) {
                        if (property.equalsIgnoreCase("sql_on_create")) ((ObjPanel)obj).setSqlOnCreate(value);
                        if (property.equalsIgnoreCase("lua_on_create")) ((ObjPanel)obj).setLuaOnCreate(value);
                        if (property.equalsIgnoreCase("extfunction_on_create")) ((ObjPanel)obj).setExtFunctionOnCreate(value);
                        if (property.equalsIgnoreCase("params_to_labels")) ((ObjPanel)obj).setParamsToLabels(value);

                    }
                    if (obj instanceof ObjTable) {
                        if (property.equalsIgnoreCase("sql_on_create")) ((ObjTable)obj).setSqlOnCreate(value);
                        if (property.equalsIgnoreCase("sql_after_click")) ((ObjTable)obj).setSqlAfterClick(value);
                        if (property.equalsIgnoreCase("lua_on_create")) ((ObjTable)obj).setLuaOnCreate(value);
                        if (property.equalsIgnoreCase("lua_after_click")) ((ObjTable)obj).setLuaAfterClick(value);
                        if (property.equalsIgnoreCase("extfunction_on_create")) ((ObjTable)obj).setExtFunctionOnCreate(value);
                        if (property.equalsIgnoreCase("extfunction_after_click")) ((ObjTable)obj).setExtFunctionAfterClick(value);
                        if (property.indexOf("column")>-1) ((ObjTable)obj).setColumn(property, value);
                        if (property.equalsIgnoreCase("valueto")) ((ObjTable)obj).setValueTo(value);
                        if (property.equalsIgnoreCase("valuefrom")) ((ObjTable)obj).setValueFrom(value);
                        if (property.equalsIgnoreCase("row_height")) {
                            if (value.equalsIgnoreCase("FILL")) ((ObjTable)obj).setRowHeight(AbsoluteLayout.LayoutParams.FILL_PARENT);
                            else if (value.equalsIgnoreCase("WRAP")) ((ObjTable)obj).setRowHeight(AbsoluteLayout.LayoutParams.WRAP_CONTENT);
                            else if (value.equalsIgnoreCase("MATCH")) ((ObjTable)obj).setRowHeight(AbsoluteLayout.LayoutParams.MATCH_PARENT);
                            else ((ObjTable)obj).setRowHeight(Integer.parseInt(value));
                        }
                        if (property.equalsIgnoreCase("divider_color")) ((ObjTable)obj).setDividerColor(value);
                        if (property.equalsIgnoreCase("divider_height")) ((ObjTable)obj).setDividerHeight(Integer.parseInt(value));
                        if (property.equalsIgnoreCase("itempanel")) ((ObjTable)obj).setItemPanel(value);
                    }
                    if (obj instanceof ObjLabel) {
                        if (property.equalsIgnoreCase("image")) ((ObjLabel)obj).setImage(value);
                        if (property.equalsIgnoreCase("lua_after_click")) ((ObjLabel)obj).setLuaAfterClick(value);
                        if (property.equalsIgnoreCase("extfunction_after_click")) ((ObjLabel)obj).setExtFunctionAfterClick(value);
                        if (property.equalsIgnoreCase("max_lines")) ((ObjLabel)obj).setMaxLines(Integer.parseInt(value));
                    }


                    if (obj instanceof ObjLabel) {
                        if (property.equalsIgnoreCase("align")) ((ObjLabel)obj).setAlign(value);
                    }
/*
                    if (obj instanceof ObjTable) {
                        if (property.equalsIgnoreCase("sql_on_create")) ((ObjTable)obj).setSqlOnCreate(value);
                        if (property.equalsIgnoreCase("sql_after_click")) ((ObjTable)obj).setSqlAfterClick(value);
                        if (property.equalsIgnoreCase("lua_on_create")) ((ObjTable)obj).setLuaOnCreate(value);
                        if (property.equalsIgnoreCase("lua_after_click")) ((ObjTable)obj).setLuaAfterClick(value);
                        if (property.indexOf("column")>-1) ((ObjTable)obj).setColumn(property,value);
                        if (property.equalsIgnoreCase("valueto")) ((ObjTable)obj).setValueTo(value);
                        if (property.equalsIgnoreCase("valuefrom")) ((ObjTable)obj).setValueFrom(value);
                        if (property.equalsIgnoreCase("row_height")) ((ObjTable)obj).setRowHeight(Integer.parseInt(value));

                    }
                    */
                    if (obj instanceof ObjBarcode) {
                        if (property.equalsIgnoreCase("sql_after_trigger")) ((ObjBarcode)obj).setSqlAfterTrigger(value);
                        if (property.equalsIgnoreCase("lua_after_trigger")) ((ObjBarcode)obj).setLuaAfterTrigger(value);
                        if (property.equalsIgnoreCase("extfunction_after_trigger")) ((ObjBarcode)obj).setExtFunctionAfterTrigger(value);
                        if (property.equalsIgnoreCase("valueto")) ((ObjBarcode)obj).setValueHolder(value);
                    }
                    if (obj instanceof ObjText)
                    {
                        if (property.equalsIgnoreCase("sql_on_change")) ((ObjText)obj).setSqlOnChange(value);
                        if (property.equalsIgnoreCase("sql_on_exit")) ((ObjText)obj).setSqlOnExit(value);
                        if (property.equalsIgnoreCase("lua_on_change")) ((ObjText)obj).setLuaOnChange(value);
                        if (property.equalsIgnoreCase("lua_on_exit")) ((ObjText)obj).setLuaOnExit(value);
                        if (property.equalsIgnoreCase("extfunction_on_change")) ((ObjText)obj).setExtFunctionOnChange(value);
                        if (property.equalsIgnoreCase("extfunction_on_exit")) ((ObjText)obj).setExtFunctionOnExit(value);
                    }


                }
            }


            return obj;
        }

        public Object create(){
            //type es name kikeresese
            Object obj =  setProperties();
            return obj;


            //		1. objektumból type kikeresése (init)
            //		2. type alapján megfelelõ class létrehozása uobjclass (uobjbutton,uobjlabel, uobjbarcode,uobjedit,uobjcombo)
        }





}
