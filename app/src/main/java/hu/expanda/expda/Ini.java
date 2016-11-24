package hu.expanda.expda;

import android.os.Environment;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;


import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class Ini {
	private static String rootDir =  Environment.getExternalStorageDirectory().getPath()+"/expda";
	private static String iniDir =  Environment.getExternalStorageDirectory().getPath()+"/expda/ini";
	private static String luaDir = Environment.getExternalStorageDirectory().getPath()+"/expda/lua";
	private static String imgDir = Environment.getExternalStorageDirectory().getPath()+"/expda/images";
	private static String exportDir = Environment.getExternalStorageDirectory().getPath()+"/expda/export";
    private static String libraryDir = Environment.getExternalStorageDirectory().getPath()+"/expda/library";
	private static String audioDir = Environment.getExternalStorageDirectory().getPath()+"/expda/audio";
	private static String updateURL =  "";
    private static String libFile = "";

    private static boolean landScape = true;
    private static boolean teszt = false;
	private static String connectionType = "php";
	private static String phpUrl = "";
    private static String[] dbMeta = {};
    private static boolean created = false;
    private static String styleFile = "style.xml";
	private static String startXML = "mainmenu.xml";
	public static void Create(){
        if (!created) {
            if (System.getProperty("expda.dir") != null)
                Ini.setIniDir("" + System.getProperty("expda.dir") + "/ini");
            new File(Ini.getIniDir()).mkdirs();
            Ini.setIniDir(Ini.getIniDir() + "/");
            String appconfig = StringFunc.getIniFile("AppConfig.xml");
            parsing(appconfig);
            created = true;
        }
		
	}
	
	public static String getIniDir() {
		return iniDir;
	}
	public static void setIniDir(String iniDir) {
		Ini.iniDir = iniDir;
	}
	
	private static String domParsing(String xmltext, String findItem,String Root) throws ParserConfigurationException, SAXException, IOException {
		String result="";
		DocumentBuilder dBuilder=DocumentBuilderFactory.newInstance().newDocumentBuilder();
		Document doc=dBuilder.parse(new InputSource(new StringReader(xmltext)));
		NodeList nList = doc.getElementsByTagName(Root);
		for (int i = 0; i < nList.getLength(); i++) {
			Node node= nList.item(i);
			if(node.getNodeType()==Node.ELEMENT_NODE){
				Element e=(Element)node;
				for (int j=0;j<e.getElementsByTagName(findItem).getLength();j++){
					if (e.getElementsByTagName(findItem).item(j).getFirstChild().hasChildNodes()) {
						for (int k=0;k<e.getElementsByTagName(findItem).item(j).getChildNodes().getLength();k++) {
							String childname = e.getElementsByTagName(findItem).item(j).getChildNodes().item(k).getNodeName();
							String aktitem = childname+"="+domParsing(xmltext, childname, findItem);
//							System.out.println("childname:"+childname+" finditem:"+findItem+" aktitem:"+aktitem);
							result+=aktitem;
						}
					}
					else {
						String aktitem = e.getElementsByTagName(findItem).item(j).getFirstChild().getNodeValue();
						result+=aktitem;
					}
					
				}
			}
		}
		return result;
	}
	
	private static void parsing(String xml){
		try {
//			Ini.setImgDir(domParsing(xml,"images_folder","Root"));
			//Ini.setLuaDir(domParsing(xml,"lua_folder","Root"));
			Ini.setExportDir(domParsing(xml,"export_folder","Root"));
			Ini.setConnectionType(domParsing(xml,"connection_type","Root"));
			Ini.setPhpUrl(domParsing(xml,"php_url","Root"));
			Ini.setTeszt(domParsing(xml,"vkod_teszt","Root").equalsIgnoreCase("true"));
            Ini.setLandScape(domParsing(xml,"orientation_landscape","Root").equalsIgnoreCase("true"));
            Ini.setDbMeta(domParsing(xml,"dbmeta","Root"));
            //Ini.setLibraryDir(domParsing(xml,"library_folder","Root"));
            Ini.setLibFile(domParsing(xml,"library_file","Root"));
//            Ini.setStyleFile(domParsing(xml,"style_file","Root"));
			Ini.setStartXML(domParsing(xml, "start_xml", "Root"));
            Ini.setUpdateURL(domParsing(xml,"update_url","Root"));
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}

	public static String getImgDir() {
		return imgDir;
	}

	public static void setImgDir(String imgDir) {
		Ini.imgDir = imgDir;
	}

	public static boolean isTeszt() {
		return teszt;
	}

	public static void setTeszt(boolean teszt) {
		Ini.teszt = teszt;
	}

	public static String getLuaDir() {
		return luaDir;
	}

	public static void setLuaDir(String luaDir) {
		Ini.luaDir = luaDir;
	}

	public static String getExportDir() {
		return exportDir;
	}

	public static void setExportDir(String exportDir) {
		Ini.exportDir = exportDir;
	}

	public static String getConnectionType() {
		return connectionType;
	}

	public static void setConnectionType(String connectionType) {
		Ini.connectionType = connectionType.toUpperCase();
	}

	public static String getPhpUrl() {
		return phpUrl;
	}

	public static void setPhpUrl(String phpUrl) {
		Ini.phpUrl = phpUrl;
	}


    public static String[] getDbMeta() {
        return dbMeta;
    }
    public static void setDbMeta(String dbMeta) {
        Ini.dbMeta = dbMeta.split(";");
    }

    public static boolean isLandScape() {
        return landScape;
    }

    public static void setLandScape(boolean landScape) {
        Ini.landScape = landScape;
    }
    public static String getStyleFile() {
        return styleFile;
    }

    public static void setStyleFile(String styleFile) {
        Ini.styleFile = styleFile;
    }
    public static void setLibraryDir(String libraryDir) {Ini.libraryDir = libraryDir;  }
    public static String getLibraryDir() {        return libraryDir;    }
    public static String getLibFile() {        return libFile;    }
    public static void setLibFile(String libFile) {        Ini.libFile = libFile;    }

    public static String getAudioDir() {
        return audioDir;
    }

    public static void setAudioDir(String audioDir) {
        Ini.audioDir = audioDir;
    }

    public static String getStartXML() {
		return startXML;
	}

	public static void setStartXML(String startXML) {
		Ini.startXML = startXML;
	}

    public static String getUpdateURL() {
        return updateURL;
    }

    public static void setUpdateURL(String updateURL) {
        Ini.updateURL = updateURL;
    }

    public static String getRootDir() {
        return rootDir;
    }
}
