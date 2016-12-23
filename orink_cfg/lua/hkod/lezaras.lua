--<verzio>20161223</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui = params[1]
azon = params[2]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'hkod_lezaras '..azon..' '.. kezelo
list=luafunc.query_assoc(str,false)
str = list[1]['RESULTTEXT']
if (str=='OK') then
       ui:executeCommand('TOAST','Lezárás rendben.')
       
else
       alert(ui,str)
       --ui:executeCommand('uzenet',str)
end
ui:executeCommand('CLOSE','','')
        


