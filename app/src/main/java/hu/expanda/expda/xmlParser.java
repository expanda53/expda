
package hu.expanda.expda;
import java.io.File;
import java.io.StringReader;
import java.util.ArrayList;


import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserFactory;

import android.content.Context;

/**
 * Created by Encsi on 2015.01.27..
 */
public class xmlParser {
    private String xmlFile = null;
    private XmlPullParserFactory xmlFactoryObject;
    public volatile boolean parsingComplete = true;
    private ArrayList<String> props = new ArrayList<>();
    private ArrayList<Object> objects=new ArrayList();
    Context context;

    public xmlParser(Context context, String fnev){
        this.context=context;
        //szelesseg fuggo xml megkeresese
        //pl
        //leltar.xml
        //leltar@1000.xml
        String minWidth = "0";
        String path = Ini.getIniDir();
        File f = new File(path);
        if (!f.exists()) f.mkdirs();
        File[] files = f.listFiles();
        if (files!=null) {
            for (int i = 0; i < files.length; i++) {
                File aktFile = files[i];
                //filenev + extensionra bontas
                String aktName = aktFile.getName().split("\\.(?=[^\\.]+$)")[0];
                //width levagasa
                String[] parts = aktName.split("@");
                if (parts.length>1) {
                    //ha a keresett filenev azonos a megtalalttal (extension és width nélkül)
                    if (parts[0].equalsIgnoreCase(fnev.split("\\.(?=[^\\.]+$)")[0])) {
                        String twidth = parts[parts.length - 1];
                        if (Integer.parseInt(twidth) < MainActivity.displayWidth && Integer.parseInt(twidth) > Integer.parseInt(minWidth)) {
                            minWidth = twidth;
                        }
                    }
                }

            }
        }

        xmlFile = fnev;
        if (!minWidth.equalsIgnoreCase("0")) {
            String[] parts = fnev.split("\\.(?=[^\\.]+$)");
            xmlFile = parts[0] + "@"+minWidth+"."+parts[1];
        }
    }


    public void parseXMLAndStoreIt(XmlPullParser myParser) {
        int event;
        String text=null;
        String components = "";
        String aktObj = "";
        String aktProp = "";

        boolean inObj = false;
        int depth = 0;
        try {
            event = myParser.getEventType();
            while (event != XmlPullParser.END_DOCUMENT) {
                String name=myParser.getName();
                depth = myParser.getDepth();
                switch (event){
                    case XmlPullParser.START_TAG:

                        if (depth == 2) {
                            //aktObj=name;
                            inObj = true;
                            aktProp = "";
                            props.clear();
                            props.add( "Type=" + name);
                        }
                        if (depth>2 && inObj){
                            aktProp = name;
                        }
                        break;
                    case XmlPullParser.TEXT:
                        text = myParser.getText();
                        break;

                    case XmlPullParser.END_TAG:
                        if(name.equalsIgnoreCase("obj")){
                            components = text;
                            inObj = false;
                        }
                        if (inObj) {
                            if (depth == 2) {
                                components += aktObj + ";";
                                if (!name.equalsIgnoreCase("obj")) {
                                    uobj uo = new uobj(aktObj, props);
                                    Object o = uo.create();
                                    if (o != null) {
                                        objects.add(o);
                                    }
                                }
                                inObj = false;
                            }
                            if (depth > 2) {
                                if (aktProp.equalsIgnoreCase("file") && text!=""){
                                    //fileból további xml beolvasás
                                    inObj = false;
                                    XmlPullParserFactory xmlFactoryObjectSub;
                                    String xmlstring = StringFunc.getIniFile(text);
                                    if (xmlstring!=null) {
                                        xmlFactoryObjectSub = XmlPullParserFactory.newInstance();
                                        XmlPullParser myparserSub = xmlFactoryObject.newPullParser();

                                        myparserSub.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES
                                                , false);
                                        myparserSub.setInput(new StringReader(xmlstring));
                                        parseXMLAndStoreIt(myparserSub);
                                    }


                                }
                                else {
                                    if (aktProp != "") {
                                        props.add(aktProp + "=" + text);
                                        if (aktProp.equalsIgnoreCase("name")) {
                                            aktObj=text;
                                        }
                                    }
                                }
                                aktProp = "";
                                text = "";
                            }
                        }

//                            humidity = myParser.getAttributeValue(null,"value");
                        break;
                }
                event = myParser.next();

            }
            parsingComplete = false;
        } catch (Exception e) {
            e.printStackTrace();
        }

    }



    public void fetchXML(){
                try {


                    String xmlstring = StringFunc.getIniFile(xmlFile);
                    if (xmlstring!=null) {
                        xmlFactoryObject = XmlPullParserFactory.newInstance();
                        XmlPullParser myparser = xmlFactoryObject.newPullParser();

                        myparser.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES
                                , false);
                        myparser.setInput(new StringReader(xmlstring));
                        parseXMLAndStoreIt(myparser);
                    }
                    else parsingComplete = false;
                } catch (Exception e) {
                    e.printStackTrace();
                }

    }
    public ArrayList<Object> getObjects() {
        return objects;
    }

}



