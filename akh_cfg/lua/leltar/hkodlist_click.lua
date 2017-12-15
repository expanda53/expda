--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()

azon = tostring(ui:findObject('lfejazon'):getText())

str = 'leltar_hkodlist ' ..kezelo..' '..azon
list=luafunc.query_assoc_to_str(str,false)
if (list~=nil) then
   luafunc.refreshtable_fromstring('hkodlist_table',list)
   ui:executeCommand('show','hkodlist_table','')
else
   ui:executeCommand('hide','hkodlist_table','')
end
ui:executeCommand("showobj","hkodlistpanel")