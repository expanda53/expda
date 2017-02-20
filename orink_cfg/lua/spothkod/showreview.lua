--<verzio>20170212</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
--atnezo panel
azon = tostring(ui:findObject('lfejazon'):getText())
str = 'spothkod_cikklist '..kezelo..' '..azon
list=luafunc.query_assoc_to_str(str,false)
if (list~=nil) then
   luafunc.refreshtable_fromstring('atnezo_table',list)
   ui:executeCommand('show','atnezo_table','')
else
   ui:executeCommand('hide','atnezo_table','')
end
ui:executeCommand("showobj","reviewpanel")


