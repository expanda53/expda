package hu.expanda.expda;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.support.v4.app.NotificationCompat;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import java.util.ArrayList;

/**
 * Created by Encsi on 2015.01.27..
 */
public class exPane {
    private Context context;
    private ObjBarcode AktBCodeObj;
    private ViewGroup layout;
    private String LuaOnCreate;

    private String extFunctionOnCreate;
    private ArrayList<Object> objects;
    private Lua lua=null;
    private extLibrary extLib;
    public static boolean dialogRes;


    private PHPClient phpcli = null;
    private dbClient dbc = null;
    public Context getContext() {
        return context;
    }
    public Activity getActivity() {
        return (Activity)context;
    }

    private boolean createPanel( String xml, String stylexml){
        dbc = new dbClient(this.getContext());
        if (MainActivity.a_style == null || MainActivity.a_style.size()==0) {
            xmlParser stobj = new xmlParser(this.getContext(), stylexml);

            stobj.fetchXML();
            while (stobj.parsingComplete) ;
            MainActivity.a_style = stobj.getObjects();
        }

        xmlParser obj = new xmlParser(this.getContext(), xml);
        obj.fetchXML();
        while (obj.parsingComplete) ;
        objects = obj.getObjects();

        for (int i = 0; i < objects.size(); i++) {
            Object o = objects.get(i);

            ViewGroup parent = layout;
            if (o instanceof ObjStyle) {
                if (MainActivity.a_style == null) MainActivity.a_style = new  ArrayList<Object>();
                if (ObjDefault.getObjStyle( ((ObjStyle)o).getName())==null)  MainActivity.a_style.add(o);

            }
            if (o instanceof ObjDefault) {
                String parentstr = ((ObjDefault) o).getParent();
                if (parentstr.equals("")) {
                    parent = layout;
                } else parent = (ViewGroup)this.findObject(parentstr);
            }

            if (o instanceof ObjLabel) {
                new exTextView(this.getContext(), o, parent,this);
            }
            if (o instanceof ObjPanel) {
                if (((ObjPanel) o).isMainPanel()){
                    setLuaOnCreate(((ObjPanel) o).getLuaOnCreate());
                    setExtFunctionOnCreate(((ObjPanel)o).getExtFunctionOnCreate());
                    if (((ObjPanel) o).getBackColor() != -1)
                        this.getLayout().setBackgroundColor(((ObjPanel) o).getBackColor());


                }
                else new exPanel(this.getContext(), o, parent);
            }
            if (o instanceof ObjButton) {
                new exButton(this.getContext(), o, parent,this);
            }
            if (o instanceof ObjText) {
                new exText(this.getContext(), o, parent,this);
            }
            if (o instanceof ObjTable) {
                if( ((ObjTable)o).getViewType().equalsIgnoreCase("list")) new exTable(this.getContext(), o, parent,this);
                else new exGrid(this.getContext(), o, parent,this);
            }

        }

        obj=null;
        return true;

    }

    public extLibrary getExtLib(){
        return extLib;
    }

    public exPane(Context c, ViewGroup layout, String xml) {
        this.layout = layout;
        this.context = c;
        createPanel(xml, Ini.getStyleFile());

        if (Ini.getConnectionType().equalsIgnoreCase("PHP")) try {
            //this.phpcli = new PHPClient(Ini.getPhpUrl());
        } catch (Exception e) {
            e.printStackTrace();
        }

        extLibrary.Create(this);


    }
    public View findObject(String name) {
        return layout.findViewWithTag(name);
    }
    private String replaceValues(String message, String paramPrefix){
        if (paramPrefix.equalsIgnoreCase("")) paramPrefix=":";
        String res=message;
        while (res.indexOf("[")>0) {
            int start = res.indexOf("[")+1;
            int end = res.indexOf("]");
            String part = res.substring(start, end);
            View o = this.findObject(part);
            String val="";
            if ( o instanceof exTextView){
                val= ((exTextView) o).getText().toString();
            }
            else
            if ( o instanceof exButton){
                val=((exButton) o).getText().toString();
            }
            else
            if ( o instanceof exText){
                val=((exText) o).getText().toString();
            }
//			res=res.replaceAll("\\["+part+"\\]", val);
            val=val.replaceAll( " ", "%20"); //szóköz lecserélése. sqlben majd vissza kell cserélni
            res=res.replaceAll("\\["+part+"\\]", paramPrefix+val); //tcp uzenetben kuldeshez :-t rakok az érték elejére, mert pl a szóköz vagy üres string nem megy át egyébként. sqlben majd le kell venni az elejéröl


        }
        return res;
    }

    public void executeCommand(String command, String p1, String p2) throws Exception{
        if ((command.equalsIgnoreCase("SHOWOBJ")) || (command.equalsIgnoreCase("HIDEOBJ"))){
            String[] objlist = p1.split( ";");
            for (int i=0;i<objlist.length;i++){
                View o = this.findObject(objlist[i]);
                boolean visbool = (command.equalsIgnoreCase("SHOWOBJ"));
                int vis = visbool?View.VISIBLE:View.INVISIBLE;
                if ( o instanceof exTextView){
                     o.setVisibility(vis);
                }
                else
                if ( o instanceof exButton) {
                     o.setVisibility(vis);
                }
                else
/*
                if ( o instanceof exImgButton) {
                    ((exImgButton) o).setVisible(vis);
                }
                else
*/

                if ( o instanceof exPanel){
                    o.setVisibility(vis);
                }

                else
                if ( o instanceof exTable){
                    o.setVisibility(vis);
                }

                else
                if ( o instanceof exGrid){
                    o.setVisibility(vis);
                }

                else
                if ( o instanceof exText){
                    o.setVisibility(vis);
                }
                else
                if (o.equals(this)) {
                    layout.setVisibility(vis);
                }

            }
        }
        else if ((command.equalsIgnoreCase("SETFOCUS")) ){
            String[] objlist = p1.split( ";");
            for (int i=0;i<objlist.length;i++){
                View o = this.findObject(objlist[i]);
                if (o != null) {
                    if (o instanceof exButton) {
                        ((exButton) o).requestFocus();
                    }
/*
                else
                if ( o instanceof exImgButton) {
                    ((exImgButton) o).setFocus();
                }
*/
                    else if (o instanceof exPanel) {
                        ((exPanel) o).requestFocus();
                    }

                else
                if ( o instanceof exTable){
                    ((exTable) o).requestFocus();
                }
                else
                if ( o instanceof exGrid){
                    ((exGrid) o).requestFocus();
                }

                    else if (o instanceof exText) {
                        ((exText) o).requestFocus();
                    } else if (o.equals(this)) {
                        this.layout.requestFocus();
                    }
                }

            }
        }

        else if ((command.equalsIgnoreCase("SETFONTCOLOR")) ){
            String[] objlist = p1.split( ";");
            for (int i=0;i<objlist.length;i++){
                View o = this.findObject(objlist[i]);
                if ( o instanceof exTextView){
                    ((exTextView) o).setFontColor(p2);
                }
                else
                if ( o instanceof exButton) {
                    ((exButton) o).setFontColor(p2);
                }
                else
                if ( o instanceof exButton) {
//                    ((exImgButton) o).setFontColor(p2);
                }
                else
                if ( o instanceof exText){
                    ((exText) o).setFontColor(p2);
                }
                else
                if ( o instanceof exPanel){
//                    ((exPanel) o).setFontColor(p2);
                }
/*
                else
                if ( o instanceof exTable){
                    ((exTable) o).setFontColor(p2);
                }
*/



            }
        }
        else if ((command.equalsIgnoreCase("SETBGCOLOR")) ){
            String[] objlist = p1.split( ";");
            for (int i=0;i<objlist.length;i++){
                View o = this.findObject(objlist[i]);
                if ( o instanceof exTextView){
                    ((exTextView) o).setBgColor(p2);
                }
                else
                if ( o instanceof exButton) {
                    ((exButton) o).setBgColor(p2);
                }
                else
/*
                if ( o instanceof exImgButton) {
                    ((exImgButton) o).setBgColor(p2);
                }
                else
*/
                if ( o instanceof exText){
                    ((exText) o).setBgColor(p2);
                }
                else
                if ( o instanceof exPanel){
                    ((exPanel) o).setBgColor(p2);
                }
/*
                else
                if ( o instanceof exTable){
                    ((exTable) o).setBgColor(p2);
                }
*/


            }
        }
        else if ((command.equalsIgnoreCase("SETWIDTH")) || (command.equalsIgnoreCase("SETHEIGHT")) || (command.equalsIgnoreCase("SETTOP")) || (command.equalsIgnoreCase("SETLEFT"))){
            String[] objlist = p1.split( ";");
            for (int i=0;i<objlist.length;i++){
                View o = this.findObject(objlist[i]);
                if ( o instanceof exTextView){
                    ((exTextView) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
                }
                else
                if ( o instanceof exButton) {
                    ((exButton) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
                }
                else
/*
                if ( o instanceof exImgButton) {
                    ((exImgButton) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
                }
                else
*/
                if ( o instanceof exText){
                    ((exText) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
                }
                else
                if ( o instanceof exPanel){
                    ((exPanel) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
                }

                else
                if ( o instanceof exTable){
                    ((exTable) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
                }
                else
                if ( o instanceof exGrid){
                    ((exGrid) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
                }



            }
        }
        /*
        else if (command.equalsIgnoreCase("SETALIGN") ){
            String[] objlist = Stringfunc.split(p1, ";");
            for (int i=0;i<objlist.length;i++){
                Control o = this.findObject(objlist[i]);
                if ( o instanceof exLabel){
                    ((exLabel) o).setAlign(p2);
                }


            }
        }
        */
        else if (command.equalsIgnoreCase("UZENET")){
            showMessage(p1);
        }

        else if (command.equalsIgnoreCase("VALUETO")){
            this.valueTo(p1,p2,false);

        }
        else if (command.equalsIgnoreCase("VALUETOHIDDEN")){
            this.valueTo(p1,p2,true);

        }

        else if (command.equalsIgnoreCase("AKTBCODEOBJ")){
            this.setAktBCodeObj(p1);
        }
        else if (command.equalsIgnoreCase("REFRESH")) {
            String[] objlist = p1.split(";");
            for (int i=0;i<objlist.length;i++){
                View o = this.findObject(objlist[i]);
                if ( o instanceof exTable){
/*
                    if (((exTable) o).getObj().getsqlOnCreate()!=null) {
                        String msg=((exTable) o).getObj().getsqlOnCreate();
//                        ((exTable) o).refresh(sendGetExecute(msg,false));
                    }
*/
                    if (((exTable) o).getObj().getLuaOnCreate()!=null) {
                        String msg=((exTable) o).getObj().getLuaOnCreate();
                        luaInit(msg); //lua.queryvel refresht kell meghivni (parsing false)
                    }
                   // ((exTable) o).refresh(null);
                }
                else
                if ( o instanceof exGrid){
                    if (((exGrid) o).getObj().getLuaOnCreate()!=null) {
                        String msg=((exGrid) o).getObj().getLuaOnCreate();
                        luaInit(msg); //lua.queryvel refresht kell meghivni (parsing false)
                    }
                }
            }

        }
        else if (command.equalsIgnoreCase("OPENXML")){
//            p1 menuitem
//            p2 kezelo
            Intent resultIntent = new Intent(this.getContext(), MainActivity.class);
            resultIntent.putExtra(MainActivity.EXTRA_MSG_ITEM,p1);
            resultIntent.putExtra(MainActivity.EXTRA_MSG_KEZELO,p2);
            getContext().startActivity(resultIntent);
//            ((Activity)getContext()).finish();

        }
        else if (command.equalsIgnoreCase("CLOSE")){
            if (lua!=null) {
                lua.stop();
                lua=null;
            }
            try {
                getActivity().finish();
            } catch (Exception e) {

            }


        }
        /*
        else if (command.equalsIgnoreCase("SCANNERON")){
            this.setScannerOn();
        }
        else if (command.equalsIgnoreCase("SCANNEROFF")){
            this.setScannerOff();
        }

        else if (command.equalsIgnoreCase("CLOSE")){
            if (lua!=null) {
                lua.stop();
                lua=null;
            }
            try {
                this.getShell().close();
            } catch (Exception e) {

            }


        }
        */
        else if (command.equalsIgnoreCase("TCPUZENET")){
            sendGetExecute(p1, true);
        }
        else if (command.equalsIgnoreCase("PHPUZENET")){
            sendGetExecute(p1, true);
        }

        else if (command.equalsIgnoreCase("STARTLUA")){
            luaInit(p1 + ' ' +p2);
        }
        else if (command.equalsIgnoreCase("STARTEXTFUNC")){
            extLibrary.runMethod(p1 + ' ' + p2);
        }
        else if (command.equalsIgnoreCase("TOAST")){
            Toast.makeText(getContext(),
                    p1,
                    Toast.LENGTH_SHORT).show();
        }
        else if (command.equalsIgnoreCase("NOTIFICATION")){
            showNotification(p1,p2);
        }




    }

    private void showNotification(String title, String text){
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this.getContext())
                        .setSmallIcon(R.drawable.ic_expanda)
                        .setLargeIcon(BitmapFactory.decodeResource(this.getContext().getResources(), R.drawable.ic_expanda))
                        .setContentTitle(title)
                        .setContentText(text);
// Creates an explicit intent for an Activity in your app
        Intent resultIntent = new Intent(this.getContext(), MainActivity.class);
        int mId = 1;
        PendingIntent resultPendingIntent = PendingIntent.getActivity(this.getContext(), 0, resultIntent, 0);
        mBuilder.setContentIntent(resultPendingIntent);
        NotificationManager mNotificationManager =
                (NotificationManager) this.getContext().getSystemService(Context.NOTIFICATION_SERVICE);
// mId allows you to update the notification later on.
        mNotificationManager.notify(mId, mBuilder.build());
    }

    public void parseTcpResponse(ArrayList response) throws Exception{
        for(int i=0;i<response.size();i++){
            String[] row = response.get(i).toString().split( "]]");
            String currCommand="";
            String currParam1="";
            String currParam2="";
            for (int j=0;j<row.length ;j++){
                String temps = parseResponse(row[j]);
                if (temps!=""){
                    String[] par = temps.split( ";");
                    if (par[0].equalsIgnoreCase("C") && (par.length>1)) currCommand = par[1];
                    if (par[0].equalsIgnoreCase("P1") && (par.length>1)) {
					/*StringBuffer result = new StringBuffer();
					for (int k = 0; k < par.length; k++) {
					   result.append( par[k]+";" );
					}
					String newstr = result.toString();
					*/
                        currParam1 = temps.replaceFirst("P1;", "");

                    }
                    if (par[0].equalsIgnoreCase("P2") && (par.length>1)) currParam2 = par[1];
                }
            }
            if (currCommand!=""){
                executeCommand(currCommand, currParam1, currParam2);
            }

        }
    }

    private String parseResponse(String row){
        String res ="";
        String[] curr = row.replace('[', ' ').trim().split( "=");
        String mezo="";
        if (curr.length>0) mezo=curr[0];
        String ertek="";
        if (curr.length>1) ertek=curr[1];

        if (curr.length>2)
        {
            for (int ix=2;ix<curr.length;ix++) {
                ertek+="="+curr[ix];
            }
        }
//		System.out.println(mezo+" "+ertek);
        if (mezo.equalsIgnoreCase("TIPUS")){
            res="C;" + ertek.toUpperCase();
        }
        if (mezo.equalsIgnoreCase("PARAM1")){
            res="P1;" + ertek;
        }
        if (mezo.equalsIgnoreCase("PARAM2")){
            res="P2;" + ertek;
        }
        return res;
    }
    public void valueTo(String objname, String value, boolean hidden){
        View o = this.findObject(objname);
        int vis = hidden?View.INVISIBLE:View.VISIBLE;

        if ( o instanceof exTextView){
            ((exTextView) o).setText(value);
            ((exTextView) o).setVisibility(vis);
        }
        else
        if ( o instanceof exButton){
            ((exButton) o).setText(value);
            ((exButton) o).setVisibility(vis);
        }
        else
        if ( o instanceof exText){
            ((exText) o).setText(value);
            ((exText) o).setVisibility(vis);
        }
        else System.out.println(objname+":"+value);

    }
    public ViewGroup getLayout() {
        return layout;
    }
    public void showMessage(String p1) {
        AlertDialog.Builder dlgAlert  = new AlertDialog.Builder(context);
        dlgAlert.setMessage(p1);
        dlgAlert.setTitle("App Title");
//        dlgAlert.setPositiveButton("OK", null);
//        dlgAlert.setCancelable(true);
        dlgAlert.setPositiveButton("Ok",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        //dismiss the dialog
                    }
                });
        dlgAlert.create().show();
    }
    public void showDialog(String p1) {
        AlertDialog.Builder dlgAlert  = new AlertDialog.Builder(context);
        dlgAlert.setMessage(p1);
        dlgAlert.setTitle("App Title");

        dlgAlert.setCancelable(true);

        dlgAlert.setPositiveButton("Igen",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        //dismiss the dialog
                        exPane.dialogRes = true;
                    }
                });

        dlgAlert.setNegativeButton("Nem",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        //dismiss the dialog
                        exPane.dialogRes = false;
                    }
                });


        dlgAlert.create().show();
    }

    public ObjBarcode getAktBCodeObj() {
        return AktBCodeObj;
    }

    public void setAktBCodeObj(String AktBCodeObjName) {
        for (int i = 0; i < objects.size(); i++) {
            Object obj = objects.get(i);
            if (obj instanceof ObjBarcode){
                if (((ObjBarcode)obj).getName().equalsIgnoreCase(AktBCodeObjName)) {
                    this.AktBCodeObj=((ObjBarcode)obj);
                }
            }
        }

    }
    public String[] extFuncInit(String params){
        String[] p2 = {};
        if (params!=null && params!="") {
            params = replaceValues(params,"");
            p2 = params.split(" ");
        }
        return p2;

    }
    public void luaInit(String params) {
        if (params!=null && params!="") {
            params = replaceValues(params,"");
            String[] p = params.split(" ");
            String[] p2 = {};
            String scrName = p[0];
            if (p.length>1){
                p2 = new String[p.length - 1];
                for (int i=1; i<p.length; i++){
                    p2[i-1]=p[i];
                }

            }
            startLua(scrName, p2);
        }
    }
    private void startLua(String scriptName, String[] params){
//        String fn = Ini.getLuaDir() + "\\" + scriptName;

        try {
            lua=new Lua(this);
            lua.load(scriptName);
            lua.setParams(params);
            lua.run();
        }
        catch (Exception e1) {
            e1.printStackTrace();
            showDialog("Script betöltés nem sikerült. Kilép?");
            if (exPane.dialogRes) {
                try {
//                    setScannerOff();
                } catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                System.exit(0);
            }
        }


    }
    public String getLuaOnCreate() {
        return LuaOnCreate;
    }
    public void setLuaOnCreate(String luaOnCreate) {
        LuaOnCreate = luaOnCreate;
    }

    public PHPClient getPhpcli() {
        return phpcli;
    }
    public ArrayList sendGetExecute(String message,boolean parsing)

    {
        if (message!=null){
            try {
                message = replaceValues(message,":");
                if (1==1 || this.getPhpcli()!=null) {
//                    ArrayList response = getPhpcli().sendMessage(message);
                    String[] s={"",""};

                    s[0] = Ini.getPhpUrl();
                    s[1] = message;
                    PHPClient phpcli = new PHPClient(s[0]);
                    phpcli.execute(s);
                    ArrayList response = null ;
                    while (response == null) {
                        response = phpcli.getResult();
                    }

                    if (parsing) {parseTcpResponse(response);return null;}
                    else {return response;}
                }
                else return null;
            }
            catch (Exception e){
                System.out.println(e.getMessage());
                try {
                    if (getPhpcli()!=null) {
                        ArrayList response = getPhpcli().sendMessage(message);
                        if (parsing) {parseTcpResponse(response);return null;}
                        else {return response;}

                    }
                    else return null;
                } catch (Exception e1) {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                    System.out.println(e.getMessage());
                    showDialog("Üzenetküldés nem sikerült.Kilép?");
                    if (exPane.dialogRes) {

                        try {
//                            setScannerOff();
                        } catch (Exception e2) {
                            // TODO Auto-generated catch block
                            e2.printStackTrace();
                        }

                        System.exit(0);
                    }
                }
                return null;
            }

        }
        else return null;
    }

    public dbClient getDbc() {
        return dbc;
    }
    public String getExtFunctionOnCreate() {
        return extFunctionOnCreate;
    }

    public void setExtFunctionOnCreate(String extFunctionOnCreate) {
        this.extFunctionOnCreate = extFunctionOnCreate;
    }




}
