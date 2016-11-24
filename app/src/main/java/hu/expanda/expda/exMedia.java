package hu.expanda.expda;

import android.content.Context;

import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;

/**
 * Created by kende on 2016. 11. 24..
 */
public class exMedia implements FilenameFilter{
    private ArrayList<exMPlayer> files ;
    public exMedia(Context c){
        String path = Ini.getAudioDir();
        File f = new File(path);
        File[] files = f.listFiles();
        this.files = new ArrayList<exMPlayer>();
        for (int i=0;i<files.length;i++){
        //for (File f in files) {
            File aktFile = files[i];
            exMPlayer mp = new exMPlayer (c, aktFile.getName());

            this.files.add(mp);
        }
    }


    @Override
    public boolean accept(File dir, String filename) {
        return filename.toLowerCase().endsWith(".mp3");
    }

    public exMPlayer getMediaByName(String name){
        for (int i=0;i<files.size();i++){
            if (files.get(i).getName().equalsIgnoreCase(name)){
                return files.get(i);
            }
        }
        return null;
    }

    public void killAll(){
        for (int i=0;i<files.size();i++){
            files.get(i).destroy();
        }
    }
}
