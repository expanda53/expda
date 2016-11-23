--<verzio>20161117</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
row = ui:findObject('cikkval_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
kod= t['KOD']
nev= t['NEV']
ui:executeCommand('toast','Választott cikk:\n[' .. kod  .. '] ' .. nev)
ui:executeCommand('hide','cikkvalpanel','')
ui:executeCommand('valueto','lcikknev',nev)
ui:executeCommand('valuetohidden','lcikod',kod)
aktmodul = tostring(ui:findObject('lmodulstat'):getText())
if (aktmodul == 'Beérkezés') then
  ui:executeCommand('showobj','cap_drb;ldrb;cap_drb2;edrb2;button_ujean','')
  ui:executeCommand('valueto','ldrb','0') 
  ui:executeCommand('valueto','edrb2','') 
  ui:executeCommand('setfocus','edrb2','') 
elseif (aktmodul=='Leltár') then
  ui:executeCommand('showobj','cap_drb;edrb;button_ujean','')
  ui:executeCommand('valueto','edrb','') 
  ui:executeCommand('setfocus','edrb','') 
end
