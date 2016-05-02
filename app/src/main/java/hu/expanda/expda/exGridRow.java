package hu.expanda.expda;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by Encsi on 2015.02.23..
 */
public class exGridRow extends LinearLayout {
    private TextView tv = null;
    public exGridRow(Context context, ObjTableCell cell){
         super(context);
         this.setOrientation(VERTICAL);

         tv = new TextView(context);
         tv.setText(cell.getData());
         tv.setTextSize(19);

         tv.setTextColor(Color.BLACK);
         tv.setTypeface(Typeface.SANS_SERIF);
         addView(tv, new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
    }

    public void setItem(Context context, ObjTableCell cell){

        get_tv().setText(cell.getData());
        get_tv().setTextSize(19);

        get_tv().setTextColor(Color.BLACK);
        get_tv().setTypeface(Typeface.SANS_SERIF);

    }
    public TextView get_tv() {
        return tv;
    }


}
