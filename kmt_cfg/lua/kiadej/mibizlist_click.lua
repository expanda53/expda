--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
row = ui:findObject('mibizlist_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
fejazon= t['AZON']
mibiz= t['MIBIZ']
ui:executeCommand('valuetohidden','lfejazon', fejazon)
ui:executeCommand('valueto','lmibiz', mibiz)
ui:executeCommand('hideobj','mibizlistpanel','')
ui:executeCommand('showobj','pfooter;button_review','')
ui:executeCommand("startlua","kiadej/ujhkod.lua", '')
