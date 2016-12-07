--<verzio>20161206</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
--atnezo panel
fejazon = tostring(ui:findObject('lfejazon'):getText())
str = 'kiadas_cikklist '..kezelo..' '..fejazon
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('atnezo_table',list)
--str = 'kiadas_review_sum '.. kezelo ..' '..mibiz
--sum=luafunc.query_assoc(str,false)
--drb = sum[1]['DRB']
--drb2 = sum[1]['DRB2']
--ui:executeCommand("valueto","losszesen",'Összesen ' .. drb .. ' drb')
--ui:executeCommand("valueto","lkiszedve",'Kiszedve ' ..drb2 .. ' drb')

ui:executeCommand("showobj","reviewpanel")


