require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
--atnezo panel
mibiz = params[2]:gsub("n",""):gsub(':','')
cikod = params[3]:gsub("n",""):gsub(':','')

str = 'gyszamleltar_gyszamlist '..mibiz..' '..cikod..' '..kezelo
list=luafunc.query_assoc_to_str(str,false)
if (list~=nil) then
  luafunc.refreshtable_fromstring('gyszam_table',list)
  ui:executeCommand("show","gyszam_table")
else
  ui:executeCommand("hide","gyszam_table")
end
ui:executeCommand("show","gyszamlistpanel")


