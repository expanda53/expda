package hu.expanda.expda;


import android.util.Log;

/**
 * Created by Encsi on 2015.01.29..
 */



    public class ObjStyle extends ObjDefault {
        private int align=0; //swt.center

    public boolean isVisibilityOverride() {
        return visibilityOverride;
    }

    public void setVisibilityOverride(boolean visibilityOverride) {
        this.visibilityOverride = visibilityOverride;
    }

    private boolean visibilityOverride = false;
    public int getAlign() {
            return align;
    }

    public void setAlign(String align) {
            if (align.equalsIgnoreCase("CENTER")) this.align = 0;//SWT.CENTER;
            if (align.equalsIgnoreCase("LEFT")) this.align = 1;//SWT.LEFT;
            if (align.equalsIgnoreCase("RIGHT")) this.align = 2;//SWT.RIGHT;
    }
}

