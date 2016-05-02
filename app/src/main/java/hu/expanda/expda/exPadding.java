package hu.expanda.expda;

import android.view.View;

/**
 * Created by Encsi on 2015.05.15..
 */
public class exPadding {
    private int top;
    private int left;
    private int right;
    private int bottom;

    public void setTop(int top){
        this.top=top;
    }
    public int getTop(){
        return this.top;
    }

    public void setLeft(int top){
        this.left=top;
    }
    public int getLeft(){
        return this.left;
    }

    public void setRight(int top){
        this.right=top;
    }
    public int getRight(){
        return this.right;
    }

    public void setBottom(int top){
        this.bottom=top;
    }
    public int getBottom(){
        return this.bottom;
    }

    public void setValues(ObjStyle s, View v){
        if (s.getPaddingTop()!=-1) this.setTop(s.getPaddingTop());
        else this.setTop(v.getPaddingTop());
        if (s.getPaddingLeft()!=-1) this.setLeft(s.getPaddingLeft());
        else this.setLeft(v.getPaddingLeft());
        if (s.getPaddingRight()!=-1) this.setRight(s.getPaddingRight());
        else this.setRight(v.getPaddingRight());
        if (s.getPaddingBottom()!=-1) this.setBottom(s.getPaddingBottom());
        else this.setBottom(v.getPaddingBottom());




    }


}
