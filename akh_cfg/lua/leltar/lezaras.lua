--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui = params[1]
azon = params[2]:gsub("n",""):gsub(':','')
mibiz = tostring(ui:findObject('lmibiz'):getText())
dialogres = params[3]    
kezelo = ui:getKezelo()
uzmod=ui:getGlobal("uzmod")
if (dialogres=="null") then
    ui:showDialog("Biztos zárható a leltár? ".. mibiz,"leltar/lezaras.lua "..azon.." igen ","leltar/lezaras.lua 0 nem")
end
if (dialogres=="igen") then
   str = 'leltar_lezaras '..azon..' '.. kezelo .. ' ' .. uzmod
   list=luafunc.query_assoc(str,false)
   result = list[1]['RESULT']
   if (result=='0') then
       ui:executeCommand('TOAST','Lezárás rendben.')
       ui:executeCommand('CLOSE','','')
   else
     if (result=='-1') then str = 'Lezárás során adatbázis hiba történt, a lezárás nem sikerült.' end
     if (result=='-2') then str = 'Van még helykód, ahol a gépi és a számolt készlet eltér. Lezárás megszakítva.' end
     if (result=='-3') then 
        str = 'Van még helykód, ami nem lett leltárazva. Lezárás megszakítva.' 
        ui:executeCommand('startlua','leltar/hkodlist_click.lua', "")
     end
     if (result=='-4') then str = 'Lezárás során egyéb hiba történt, a lezárás nem sikerült.' end
     alert(ui,str)
   end
end

