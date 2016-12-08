package hu.expanda.expda;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.Gravity;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Created by kende on 2016. 12. 08..
 */
    public class exToast extends Activity
    {
        static CountDownTimer timer =null;
        Toast toast;
        int duration = 3;
        String text = "";

        public exToast(Context c,String text, int duration){
            this.duration = duration;
            this.text=text;
            toast = new Toast(c);
            TextView textView=new TextView(c);
            textView.setTextColor(Color.BLACK);
            //textView.setBackgroundColor(Color.WHITE);
            textView.setTextSize(16);
            textView.setText(text);

            GradientDrawable gd = new GradientDrawable();
            gd.setColor(Color.WHITE); // Changes this drawbale to use a single color instead of a gradient
            gd.setCornerRadius(2);
            gd.setStroke(1, Color.parseColor("#434343"));
            textView.setPadding(10,10,10,10);

            textView.setBackground(gd);


            toast.setGravity(Gravity.CENTER_VERTICAL, 0, 0);

            toast.setView(textView);
        }

        public void start()
        {
            timer =new CountDownTimer(duration*1000, 1000)
            {
                public void onTick(long millisUntilFinished)
                {
                    toast.show();
                }
                public void onFinish()
                {
                    toast.cancel();
                }

            }.start();

        }
    }

