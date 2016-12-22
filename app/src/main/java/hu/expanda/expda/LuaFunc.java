package hu.expanda.expda;

/**
 * Created by Encsi on 2015.02.07..
 */


        import android.util.Log;
        import android.view.View;
        import android.view.ViewGroup;

        import java.io.File;
        import java.io.FilenameFilter;
        import java.util.ArrayList;
        import java.util.Date;

        import org.luaj.vm2.LuaString;
        import org.luaj.vm2.LuaValue;
        import org.luaj.vm2.lib.OneArgFunction;
        import org.luaj.vm2.lib.TwoArgFunction;
        import org.luaj.vm2.lib.jse.CoerceJavaToLua;


public class LuaFunc extends TwoArgFunction {
    private static exPane pane = null;
    private static ViewGroup layout = null;
    private static dbClient dbc= null;
    private static final String LOG = LuaFunc.class.getName();
    public LuaFunc() {

    }

    public void addPane(exPane pane){
        LuaFunc.pane = pane;
        LuaFunc.layout = pane.getLayout();
        LuaFunc.dbc = pane.getDbc();
    }



    public LuaValue call(LuaValue modname, LuaValue env) {
        LuaValue library = tableOf();
        library.set("query", new query());
        library.set("query_assoc", new query_assoc());
        library.set("query_assoc_to_str", new query_assoc_to_str());
        library.set("strtotable", new strToTable());
        library.set("rowtotable", new RowToTable());
        library.set("refreshtable", new refresh_table());
        library.set("refreshtable_fromstring", new refresh_table_from_string());
        library.set("findFiles", new findFiles());
        library.set("findFilesByDate", new findFilesByDate());
        library.set("ini", new iniGet());
        library.set("isql_query", new isql_query());
        library.set("isql_exec", new isql_exec());
        library.set("log", new log());
//        library.set("isql_query_asoc", new isql_query_assoc());
        env.set( "luafunc", library );
        return library;
    }
    static class query extends TwoArgFunction {
        public LuaValue call(LuaValue sql,LuaValue parsing){
//			parsing false esetén nem dolgozza fel a kapott arraylistet, csak visszaadja. true esetén feldolgozza és nilt ad vissza

            if (/*pane.getTcp()==null &&*/ pane.getPhpcli()==null) {
                pane.showDialog("Üzenetküldés nem sikerült.Kilép?");
                if (exPane.dialogRes) System.exit(0);
            }


            ArrayList list = pane.sendGetExecute(sql.tojstring(), parsing.toboolean());
            if (list!=null && list.size()!=0) {
                LuaValue rows = tableOf();
                for(int i=0;i<list.size();i++){
                    String row = list.get(i).toString();
                    rows.set(i+1,row);
                }
                return rows;
            }
            else return CoerceJavaToLua.coerce( null);


        }
    }



    static class query_assoc extends TwoArgFunction {
        public LuaValue call(LuaValue sql,LuaValue parsing){
//			parsing false esetén nem dolgozza fel a kapott arraylistet, csak visszaadja. true esetén feldolgozza és nilt ad vissza

            ArrayList list = pane.sendGetExecute(sql.tojstring(), parsing.toboolean());
            if (list!=null && list.size()!=0) {
                LuaValue rows = tableOf();
                for(int i=0;i<list.size();i++){
                    LuaValue cols = tableOf();
                    String[] row = list.get(i).toString().split( "]]");
                    for (int j=0;j<row.length;j++){
                        String[] field = row[j].split( "=");
                        String val = "";
                        if (field.length==1) val = "";
                        else val = field[1];
                        cols.set(field[0].replace('[', ' ').trim(), val);

                    }
                    rows.set(i+1, cols);
                }
                return rows;
            }
            else return CoerceJavaToLua.coerce( null);


        }
    }

    static class query_assoc_to_str extends TwoArgFunction {
        public LuaValue call(LuaValue sql,LuaValue parsing){
//			parsing false esetén nem dolgozza fel a kapott arraylistet, csak visszaadja. true esetén feldolgozza és nilt ad vissza
            String rows = "";
            ArrayList list = pane.sendGetExecute(sql.tojstring(), parsing.toboolean());
            if (list!=null && list.size()!=0) {
                for(int i=0;i<list.size();i++){
                    if (list.get(i).toString().trim()!="") {
                        rows += list.get(i).toString().trim();
                        if (rows!="" && rows.charAt(rows.length()-1)==']') rows+="\n";
                    }

                }
                return LuaValue.valueOf(rows);
            }
            else return CoerceJavaToLua.coerce( null);


        }
    }

    static class isql_query extends TwoArgFunction {
        public LuaValue call(LuaValue sql,LuaValue parsing){
//			parsing false esetén nem dolgozza fel a kapott arraylistet, csak visszaadja. true esetén feldolgozza és nilt ad vissza

//            if ( pane.getPhpcli()==null) {
//                pane.showDialog("Üzenetküldés nem sikerült.Kilép?");
//                if (exPane.dialogRes) System.exit(0);
//            }


//            ArrayList list = pane.sendGetExecute(sql.tojstring(), parsing.toboolean());
            ArrayList list = dbc.Query(sql.tojstring());
//            ArrayList list = db.Query(sql.tojstring());
            if (parsing.toboolean()) {
                try {
                    pane.parseTcpResponse(list);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if (list!=null) {
//                LuaValue rows = tableOf();
                LuaString str = null;

                String val  = "";
                for(int i=0;i<list.size();i++){
                    String row = list.get(i).toString();
                    val += row+"\n";
//                    rows.set(i+1,row);
                }
                str = LuaString.valueOf(val);
                return LuaFunc.totable(str);
                // return rows;
            }
            else return CoerceJavaToLua.coerce( null);


        }
    }

    static class isql_exec extends OneArgFunction {
        public LuaValue call(LuaValue sql){
//			parsing false esetén nem dolgozza fel a kapott arraylistet, csak visszaadja. true esetén feldolgozza és nilt ad vissza

//            if ( pane.getPhpcli()==null) {
//                pane.showDialog("Üzenetküldés nem sikerült.Kilép?");
//                if (exPane.dialogRes) System.exit(0);
//            }


            dbc.Exec(sql.tojstring());
            return CoerceJavaToLua.coerce( null);


        }
    }

    static class log extends OneArgFunction {
        public LuaValue call(LuaValue logstr){
            Log.w(LuaFunc.LOG,logstr.tojstring());
            return CoerceJavaToLua.coerce( null);


        }
    }

    static class refresh_table extends TwoArgFunction {
        public LuaValue call(LuaValue objname, LuaValue res){
            ArrayList list=new ArrayList();
            for (int i=1;i<=res.length();i++){
                list.add(res.get(i));
            }

            View o = pane.findObject(objname.tojstring());
            if ( o instanceof exTable){

                ((exTable) o).refresh(list);

            }
            else
            if ( o instanceof exGrid){
                ((exGrid) o).refresh(list);
            }
            else
            if ( o instanceof exSpinner){
                ((exSpinner) o).refresh(list);
            }
            return null;
        }
    }
    static class refresh_table_from_string extends TwoArgFunction {
        public LuaValue call(LuaValue objName, LuaValue res){

            String content = res.tojstring();
            ArrayList arrlist = new ArrayList();
            View o = pane.findObject(objName.tojstring());
            if ( o instanceof exTable){
                String[] rows = content.split( "\n");

                if (rows.length>0){
                    for (int j=0; j<rows.length; j++){
                        arrlist.add(rows[j] );
                    }

                }
                ((exTable) o).refresh(arrlist);

            }
            else
            if ( o instanceof exGrid){
                String[] rows = content.split( "\n");

                if (rows.length>0){
                    for (int j=0; j<rows.length; j++){
                        arrlist.add(rows[j] );
                    }

                }
                ((exGrid) o).refresh(arrlist);

            }
            else
            if ( o instanceof exSpinner){
                String[] rows = content.split( "\n");

                if (rows.length>0){
                    for (int j=0; j<rows.length; j++){
                        arrlist.add(rows[j] );
                    }

                }
                ((exSpinner) o).refresh(arrlist);

            }
            return null;
        }
    }

    static class findFiles extends OneArgFunction {
        public LuaValue call(LuaValue lfilter) {
/*
            String res = "";
            File dir = new File(Ini.getExportDir());
            final String fn = lfilter.tojstring();
            FilenameFilter filter = new FilenameFilter() {
                public boolean accept
                        (File dir, String name) {

                    return name.indexOf(fn)>-1;
                }
            };
            String[] children = dir.list(filter);
            if (children == null) {
                System.out.println("Either dir does not 		         exist or is not a directory");
            }
            else {
                for (int i=0; i< children.length; i++) {
                    String filename = children[i];
                    if (res!="") res+=",";
                    res += filename;
//		            System.out.println(filename);
                }
            }

            return LuaValue.valueOf(res);
*/
            return null;
        }
    }


    static class findFilesByDate extends OneArgFunction {
        public LuaValue call(LuaValue ldays) {
/*
            String res = "";
            File dir = new File(Ini.getExportDir());
            int days = ldays.toint();
            Date now = new Date();
            final long min = now.getTime() - (days * 24  * 60 * 60 * 1000); //x nap
            FilenameFilter filter = new FilenameFilter() {
                public boolean accept
                        (File dir, String name) {
                    File f = new File(Ini.getExportDir() + "\\" + name);
                    return f.lastModified()  <min;
                }
            };
            String[] children = dir.list(filter);
            if (children == null) {
                System.out.println("Either dir does not 		         exist or is not a directory");
            }
            else {
                for (int i=0; i< children.length; i++) {
                    String filename = children[i];
                    if (res!="") res+=",";
                    res += filename;
                }
            }

            return LuaValue.valueOf(res);
*/
            return null;
        }
    }

    static LuaValue totable(LuaValue content){
        String[] lines = content.tojstring().split("\n");

        ArrayList list=new ArrayList();
        for (int i=0;i<lines.length;i++){
            list.add(lines[i]);
        }


        LuaValue rows = tableOf();
        for(int i=0;i<list.size();i++){
            LuaValue cols = tableOf();
            String[] row = list.get(i).toString().split("]]");
            for (int j=0;j<row.length;j++){
                String[] field = row[j].split("=");
                String val = "";
                if (field.length==1) val = "";
                else val = field[1];
                cols.set(field[0].replace('[', ' ').trim(), val);
            }
            rows.set(i+1, cols);
        }
        return rows;

    }

    static class strToTable extends OneArgFunction {
        public LuaValue call(LuaValue content){
            return LuaFunc.totable(content);
        }
    }


    static class RowToTable extends OneArgFunction {
        public LuaValue call(LuaValue content){

            ArrayList<ObjTableCell> list = (ArrayList<ObjTableCell>) content.touserdata();

            LuaValue cols = tableOf();
            for(int i=0;i<list.size();i++){
                    String field = list.get(i).getTitle();
                    String val = list.get(i).getData();


                    cols.set(field.trim(), val);
            }
            return cols;
        }
    }

    static class iniGet extends OneArgFunction {
        public LuaValue call(LuaValue iniItem) {

            LuaValue res = LuaValue.valueOf("") ;
            if (iniItem.tojstring().equalsIgnoreCase("exportdir")) res = LuaValue.valueOf(Ini.getExportDir());
            if (iniItem.tojstring().equalsIgnoreCase("luadir")) res = LuaValue.valueOf(Ini.getLuaDir());
            if (iniItem.tojstring().equalsIgnoreCase("inidir")) res = LuaValue.valueOf(Ini.getIniDir());
            if (iniItem.tojstring().equalsIgnoreCase("imagesdir")) res = LuaValue.valueOf(Ini.getImgDir());
            return res;
        }
    }

}
