--<verzio>20161121</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]


row = ui:findObject('ceglist_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
cegnev= t['NEV']
cegazon= t['AZON']
ui:executeCommand('valueto','lcegazon', cegazon)
ui:executeCommand('valueto','lcegnev', cegnev)
ui:executeCommand('hideobj','ceglistpanel','')
ui:executeCommand('showobj','pfooter;cap_ean;eean;button_review','')
ui:executeCommand('aktbcodeobj','bcode1','')

kezelo = ui:getKezelo()
str = 'beerk_bizkeres ' .. cegazon .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
fejazon=t[1]['AZON']
mibiz=t[1]['MIBIZ']
ui:executeCommand('valuetohidden','lfejazon', fejazon)
ui:executeCommand('valueto','lmibiz', mibiz)



