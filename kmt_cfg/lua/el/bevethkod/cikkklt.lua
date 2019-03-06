--<verzio>20170725</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
cikod = params[2]:gsub("n",""):gsub(':','')
ui:executeCommand('hide','pfooter','')
str = 'hkod_cikkklt '..cikod..' '.. kulsoraktar
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('cikkklt_table',list)
if (list~=nil) then
   luafunc.refreshtable_fromstring('cikkklt_table',list)
   ui:executeCommand('show','cikkklt_table','')
else
   ui:executeCommand('hide','cikkklt_table','')
end

cikknev = tostring(ui:findObject('lcikknev'):getText())
ean = tostring(ui:findObject('eean'):getText())
ui:executeCommand("valueto","lcikknevp",cikknev)
ui:executeCommand('aktbcodeobj','bcode_ckp','')
--ui:setGlobal("aktbcodeobj",'bcode_ckp')
ui:executeCommand('valueto','eean_ckp',ean)   
ui:executeCommand('setfocus','eean_ckp','')   
ui:executeCommand("showobj","cikkkltpanel")


