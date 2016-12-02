--<verzio>20161202</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]


row = ui:findObject('mibizlist_table'):getSelectedRow()  
--txt = row:toString()
--ui:executeCommand('uzenet',txt)
t = luafunc.rowtotable(row)

cegnev= t['CEGNEV']
mibiz= t['MIBIZ']
azon= t['AZON']
ui:executeCommand('valuetohidden','lfejazon', azon)
ui:executeCommand('valueto','lmibiz', mibiz)
ui:executeCommand('valueto','lcegnev', cegnev)
ui:executeCommand('hideobj','mibizlist_table','')

ui:executeCommand('showobj','pfooter;button_review;button_kovetkezo;button_elozo','')
ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', azon..' . . 1')
ui:executeCommand('aktbcodeobj','bcode1','')
