--<verzio>20170725</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
hkod = params[2]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
ui:executeCommand('hide','pfooter','')
str = 'hkod_hkklt '..hkod .. ' ' .. kulsoraktar
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('hkodklt_table',list)
if (list~=nil) then
   luafunc.refreshtable_fromstring('hkodklt_table',list)
   ui:executeCommand('show','hkodklt_table','')
else
   ui:executeCommand('hide','hkodklt_table','')
end
ui:executeCommand("showobj","hkodkltpanel")
ui:executeCommand('aktbcodeobj','bcode_hkp','')
ui:executeCommand('valueto','ehkod_hkp',hkod)   
ui:executeCommand('setfocus','ehkod_hkp','')   


