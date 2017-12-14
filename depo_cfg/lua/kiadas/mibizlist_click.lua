--<verzio>20171012</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]


row = ui:findObject('mibizlist_table'):getSelectedRow()  
--txt = row:toString()
--ui:executeCommand('uzenet',txt)
t = luafunc.rowtotable(row)

cegnev= t['CEGNEV']
mibiz= t['MIBIZ']
ui:executeCommand('valueto','lmibiz', mibiz)
ui:executeCommand('valueto','lcegnev', cegnev)
ui:executeCommand('hideobj','mibizlist_table;btn_mibizvissza','')
ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', '')
