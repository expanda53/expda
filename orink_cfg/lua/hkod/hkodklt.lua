--<verzio>20161123</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
hkod = params[2]:gsub("n",""):gsub(':','')
str = 'hkod_hkklt '..hkod
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('hkodklt_table',list)
if (list~=nil) then
   luafunc.refreshtable_fromstring('hkodklt_table',list)
   ui:executeCommand('show','hkodklt_table','')
else
   ui:executeCommand('hide','hkodklt_table','')
end
ui:executeCommand("showobj","hkodkltpanel")


