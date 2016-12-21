--<verzio>20161215</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]


row = ui:findObject('ceglist_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
cegnev= t['NEV']
cegazon= t['AZON']
rentip= t['RENTIP']
ui:executeCommand('valuetohidden','lrentip', rentip)
ui:executeCommand('valuetohidden','lcegazon', cegazon)
ui:executeCommand('valueto','lcegnev', cegnev..' ('..rentip..')')
ui:executeCommand('hideobj','ceglistpanel','')
ui:executeCommand('showobj','pfooter;cap_ean;eean;button_review;button_cikkval','')
ui:executeCommand('aktbcodeobj','bcode1','')

kezelo = ui:getKezelo()
str = 'beerk_bizkeres ' .. cegazon .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
fejazon=t[1]['AZON']
mibiz=t[1]['MIBIZ']
ui:executeCommand('valuetohidden','lfejazon', fejazon)
ui:executeCommand('valueto','lmibiz', mibiz)



