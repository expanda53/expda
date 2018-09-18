--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
row = ui:findObject('ceglist_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
cegnev= t['NEV']
fejazon= t['AZON']
mibiz= t['MIBIZ']
ui:executeCommand('valuetohidden','lfejazon', fejazon)
ui:executeCommand('valueto','lcegnev', cegnev)
ui:executeCommand('valueto','lmibiz', mibiz)
ui:executeCommand('hideobj','ceglistpanel','')
ui:executeCommand('showobj','pfooter;cap_hkod;ehkod;button_review','')
ui:executeCommand('aktbcodeobj','bcode_hkod','')

kezelo = ui:getKezelo()
--kulsoraktar = ui:getGlobal("kulsoraktar")
--str = 'beerk_bizkeres ' .. cegazon .. ' ' .. kezelo .. ' ' .. kulsoraktar
--t=luafunc.query_assoc(str,false)
--fejazon=t[1]['AZON']
--mibiz=t[1]['MIBIZ']
--ui:executeCommand('valuetohidden','lfejazon', fejazon)
--ui:executeCommand('valueto','lmibiz', mibiz)



