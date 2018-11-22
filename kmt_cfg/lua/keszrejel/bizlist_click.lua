--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
row = ui:findObject('bizlist_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
fejazon= t['AZON']
mibiz= t['MIBIZ']
ui:executeCommand('valuetohidden','lfejazon', fejazon)
ui:executeCommand('valueto','lmibiz', mibiz)
ui:executeCommand('hideobj','bizlistpanel','')
ui:executeCommand('showobj','pfooter;cap_cikod;ecikod;button_review','')
ui:executeCommand('aktbcodeobj','bcode0','')

kezelo = ui:getKezelo()
