--<verzio>20170220</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui = params[1]
azon = params[2]:gsub("n",""):gsub(':','')
if (#params>=3) then
  dialogres = params[3]    
else
  dialogres = "null"
end  
if (dialogres=="null") then
    mibiz = tostring(ui:findObject('lmibiz'):getText())
    ui:showDialog("Biztos lezárja a spotleltárt? ".. mibiz,"spothkod/lezaras.lua " .. azon .. " igen ","spothkod/lezaras.lua 0 nem")
end
if (dialogres=="igen") then
    kezelo = ui:getKezelo()
    kulsoraktar = ui:getGlobal("kulsoraktar")
    str = 'spothkod_lezaras '..azon..' '.. kezelo..' ' ..kulsoraktar
    list=luafunc.query_assoc(str,false)
    str = list[1]['RESULTTEXT']
    if (str=='OK') then
           ui:executeCommand('TOAST','Lezárás rendben.')
           
    else
           alert(ui,str)
           --ui:executeCommand('uzenet',str)
    end
    ui:executeCommand('CLOSE','','')
end        


