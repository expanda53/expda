package hu.expanda.expda;

/**
 * Created by Encsi on 2015.02.09..
 */

        import java.io.BufferedReader;
        import java.io.File;
        import java.io.FileReader;
        import java.io.IOException;
        import java.util.ArrayList;



public class StringFunc {


    public static ArrayList readFiletoArrayList( String file ) throws IOException {
        BufferedReader reader = new BufferedReader( new FileReader (file));
        String         line = null;
        ArrayList res = new ArrayList();
//	    String         ls = System.getProperty("line.separator");

        while( ( line = reader.readLine() ) != null ) {
            res.add( line );
//	        res.add( ls );
        }

        return res;
    }

    public static String readFiletoString( String file ) throws IOException {
        BufferedReader reader = new BufferedReader( new FileReader (file));
        String         line = null;
        String res = "";
//	    String         ls = System.getProperty("line.separator");

        while( ( line = reader.readLine() ) != null ) {
            res+= line.trim();
//	        res.add( ls );
        }

        return res;
    }

    public static String getFile(String fn){
        String xmlstring2 = "";
        String xmlnev = Ini.getIniDir()+fn;
        //xmlnev = "./expda/ini/AppConfig.xml";
        if (new File(xmlnev ).exists()) {
            try {
                xmlstring2 = StringFunc.readFiletoString(xmlnev);
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        else {
            xmlstring2 = null;
        }
        return xmlstring2;
    }
    public static String getLua(String fn){
        String xmlstring2 = "";
        String xmlnev = Ini.getLuaDir()+"/"+fn;
        if (new File(xmlnev ).exists()) {
            try {
                xmlstring2 = StringFunc.readFiletoString(xmlnev);
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        else {
            xmlstring2 = null;
        }
        return xmlstring2;
    }

}
