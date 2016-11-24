--<verzio>20161117</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
azon = params[2]:gsub("n",""):gsub(':','')
mibiz = tostring(ui:findObject('lmibiz'):getText())
dialogres = params[3]    
kezelo = ui:getKezelo()
if (dialogres=="null") then
    ui:showDialog("Biztos zárható a leltár? ".. mibiz,"leltar/lezaras.lua "..azon.." igen ","leltar/lezaras.lua 0 nem")
end
if (dialogres=="igen") then
   str = 'leltar_lezaras '..azon..' '.. kezelo
   list=luafunc.query_assoc(str,false)
   str = list[1]['RESULTTEXT']
   if (str=='OK') then
       ui:executeCommand('TOAST','Lezárás rendben.')
       ui:executeCommand('CLOSE','','')
   else
       ui:executeCommand('uzenet',str)
   end
        
end

