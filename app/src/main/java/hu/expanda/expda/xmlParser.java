
package hu.expanda.expda;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.util.ArrayList;


import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;

import android.app.Application;
import android.content.Context;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

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
        xmlFile = fnev;

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
                                    String xmlstring = StringFunc.getFile(text);
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


                    String xmlstring = StringFunc.getFile(xmlFile);
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



