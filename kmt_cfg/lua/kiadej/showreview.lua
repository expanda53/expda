--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
--atnezo panel
azon = tostring(ui:findObject('lfejazon'):getText())
str = 'kiadej_cikklist '..kezelo..' '..azon
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('atnezo_table',list)
ui:executeCommand("showobj","reviewpanel")


