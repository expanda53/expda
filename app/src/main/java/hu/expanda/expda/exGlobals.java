package hu.expanda.expda;

import java.util.ArrayList;

/**
 * Created by kende on 2016. 12. 20..
 */
public class exGlobals {
    public static class Item {
        private int index=-1;
        private String value="";
        public Item (int index, String value){
          this.index = index;
            this.value=value;
        }
        public Item(){
        }
        public String getValue(){
            return value;
        }
        public int getIndex(){
            return index;
        }
    }
    private static ArrayList<String> globals = new ArrayList<>();
    public exGlobals(String params){
        setGlobals(params);

    }

    public static ArrayList<String> getGlobals() {
        return globals;
    }

    public static void setGlobals(String globals) {
        if (globals!=null) {
            exGlobals.getGlobals().clear();
            String[] Items = globals.split(";");
            for (int i = 0; i < Items.length; i++) {
                exGlobals.addItem(Items[i]);
            }
        }
    }
    public static void addItem(String optionWithValue ){
        exGlobals.getGlobals().add(optionWithValue);
    }

    public static void addItem(String option, String value ){
        Item aktItem = getItemByName(option);
        if (aktItem!=null) {
            exGlobals.getGlobals().set(aktItem.getIndex(),option+"="+value);
        }
        else exGlobals.getGlobals().add(option+"="+value);
    }

    public static Item getItemByName(String option){
        Item result=null;
        if (getGlobals()!=null) {
            for (int i = 0; i < getGlobals().size(); i++) {
                String[] aktItem = getGlobals().get(i).split("=");
                if (aktItem[0].equalsIgnoreCase(option)) result = new Item(i, aktItem[1]);
            }
        }
        return result;
    }


    public static String toStringRow() {
        String result = "";
        if (getGlobals()!=null) {
            for (int i = 0; i < getGlobals().size(); i++) {
                result += getGlobals().get(i);
            }
        }
        return result;
    }
}
