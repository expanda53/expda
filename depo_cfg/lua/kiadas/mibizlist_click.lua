--<verzio>20170617</verzio>
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

ui:executeCommand('showobj','pfooter;eean;button_review;button_kovetkezo;button_elozo','')
ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', mibiz..' 0 +')
