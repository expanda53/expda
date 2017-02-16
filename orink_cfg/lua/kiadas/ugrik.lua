--<verzio>20170201</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
fejazon = params[2]:gsub("\n",""):gsub(':','')

row = ui:findObject('atnezo_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
cikk= t['CIKK']
hkod= t['HKOD']:gsub("Helykód","")
ui:executeCommand("hideobj","reviewpaneldlg;reviewpanel")
ui:executeCommand('startlua','kiadas/kovetkezo_click.lua',fejazon..' '..hkod..' '..cikk..' 0')



