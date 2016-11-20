--<verzio>20161117</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
row = ui:findObject('cikkval_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
kod= t['KOD']
nev= t['NEV']
ui:executeCommand('valuetohidden','lcikod',kod) 
ui:executeCommand('toast','Választott cikk:\n[' .. kod  .. '] ' .. nev)
ui:executeCommand('hide','cikkvalpanel','')