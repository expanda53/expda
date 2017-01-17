--<verzio>20161121</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
--atnezo panel
fejazon = tostring(ui:findObject('lfejazon'):getText())
str = 'beerk_cikklist ' .. kezelo .. ' ' .. fejazon
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('atnezo_table',list)
ui:executeCommand("showobj","reviewpanel")


