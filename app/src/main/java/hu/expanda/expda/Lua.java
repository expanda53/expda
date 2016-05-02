package hu.expanda.expda;



/**
 * Created by Encsi on 2015.02.05..
 */

import android.view.ViewGroup;

import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.Varargs;
import org.luaj.vm2.lib.jse.CoerceJavaToLua;
import org.luaj.vm2.lib.jse.JsePlatform;


public class Lua {
    private Globals globals;
    private LuaValue luaObj;
    private Varargs p=null;


    private exPane pane;

    public Lua(exPane pane) {
        this.pane = pane;
        this.globals = JsePlatform.standardGlobals();
        LuaValue h = new LuaFunc();
        ((LuaFunc)h).addPane(pane);
        this.globals.load(new LuaFunc());

    }

    public void load(String par){
//        String content = StringFunc.getLua(par);
        this.luaObj=this.globals.loadfile(Ini.getLuaDir()+"/"+par);
//        this.luaObj=this.globals.load("local params = {...};ui = params[1];ltext = params[2]; ui:executeCommand('valueto','lkezelo',ltext);ui:executeCommand('UZENET','teszt','');");
    }

    public void run(){
        this.getLuaObj().invoke(p);
    }
    public void stop(){
        luaObj = null;
    }

    public void setParams(String[] par){
        int parnr = par.length + 1;
        LuaValue[] pluav = new LuaValue[parnr];
        pluav[0] = CoerceJavaToLua.coerce(this.pane);
        if (par.length>0) {
            for ( int i = 0; i < par.length ; i++) {
                pluav[i+1] = LuaValue.valueOf(par[i]);

            }
        }

        p = LuaValue.varargsOf(pluav);
    }

    public LuaValue getLuaObj() {
        return luaObj;
    }

    public String getString(){
        return "tesztstring";
    }


}

