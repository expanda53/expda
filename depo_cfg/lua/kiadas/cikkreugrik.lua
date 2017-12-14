--<verzio>20171012</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
--ui:executeCommand('uzenet',dialogres)
row = ui:findObject('atnezo_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
ean= t['EAN']
ui:executeCommand('hideobj','kerdespanel;reviewpanel','')
ui:executeCommand('valueto','eean', ean)
ui:executeCommand('startlua','kiadas/bcode1.lua', ean)
