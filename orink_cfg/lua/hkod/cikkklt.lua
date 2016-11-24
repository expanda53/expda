--<verzio>20161123</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
cikod = params[2]:gsub("n",""):gsub(':','')
str = 'hkod_cikkklt '..cikod
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('cikkklt_table',list)
if (list~=nil) then
   luafunc.refreshtable_fromstring('cikkklt_table',list)
   ui:executeCommand('show','cikkklt_table','')
else
   ui:executeCommand('hide','cikkklt_table','')
end

cikknev = tostring(ui:findObject('lcikknev'):getText())
ui:executeCommand("valueto","lcikknevp",cikknev)
ui:executeCommand("showobj","cikkkltpanel")


