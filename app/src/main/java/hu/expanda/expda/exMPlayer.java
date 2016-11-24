package hu.expanda.expda;

import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;

import java.io.File;
import java.io.IOException;

/**
 * Created by kende on 2016. 11. 24..
 */
public class exMPlayer {
    private String name;
    private MediaPlayer mediaPlayer;
    public exMPlayer (Context c,String name)  {
        this.name =name;
        if (!name.equals("")) {
            Uri myUri = Uri.fromFile(new File(Ini.getAudioDir()+'/'+name));
            setName(name);
            // initialize Uri here
            mediaPlayer = MediaPlayer.create(c,myUri);
            mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            /*try {
                mediaPlayer.setDataSource(c, myUri);
            } catch (IOException e) {
                e.printStackTrace();
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (SecurityException e) {
                e.printStackTrace();
            } catch (IllegalStateException e) {
                e.printStackTrace();
            }
            */
            /*
            mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                public void onCompletion(MediaPlayer mp) {
                    mp.release();

                }

                ;
            });*/

        }


    }

    public void play()  {
/*        try {
            //getMediaPlayer().prepare();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (IllegalStateException e) {
            e.printStackTrace();
        }
*/
        getMediaPlayer().start();

    }

    public void destroy(){
        getMediaPlayer().release();
        mediaPlayer=null;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public MediaPlayer getMediaPlayer() {
        return mediaPlayer;
    }
}
