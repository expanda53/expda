--<verzio>20170201</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
row = ui:findObject('atnezo_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
cikknev= t['CIKKNEV']
aktdrb = t['DRB2']
if (aktdrb==nil or aktdrb=='') then
   aktdrb='0'
else
   aktdrb = aktdrb:gsub("Kiszedve: ","")
end
if (tonumber(aktdrb)>0) then
   ui:executeCommand("showobj","btn_javit")
else
   ui:executeCommand("hideobj","btn_javit")
end
ui:executeCommand("valueto","ldlgcikknev",cikknev)
ui:executeCommand("showobj","reviewpaneldlg")


    
