--<verzio>20170329</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("showprogress","Megnyitás...","")
filterstr = params[2]:gsub("%%20"," "):gsub(":","")
biztip=""
if (filterstr=="Mind") then
  biztip=""
elseif (filterstr=="Belfoldi") then
  biztip="AF12"
else
  biztip="AF15"
end
ui:executeCommand('valuetohidden','lbiztip',biztip)
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
ui:executeCommand("hideobj","mibizlist_table")
str = 'ellenor_mibizlist '..kezelo .. ' ' .. kulsoraktar 
--.. ' ' .. biztip
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('mibizlist_table',list)
ui:executeCommand("showobj","mibizlist_table")
ui:executeCommand("hideprogress","","")


