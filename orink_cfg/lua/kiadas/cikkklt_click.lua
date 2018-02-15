--<verzio>20180118</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
kezelo = ui:getKezelo()
row = ui:findObject('cikkklt_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
hkod= t['HKOD']
aktdrb = t['DRB']
if (aktdrb==nil or aktdrb=='') then
   aktdrb='0'
end
if (tonumber(aktdrb)>0) then
   azon = tostring(ui:findObject('lfejazon'):getText())
   cikod = tostring(ui:findObject('lcikod'):getText())
   str = 'kiadas_hkodupdate ' .. kezelo .. ' ' .. azon .. ' ' .. cikod .. ' ' .. hkod
   t=luafunc.query_assoc(str,false)
   result = t[1]['RESULT'] 
   if (result=='0') then
     ui:executeCommand("toast","Helykód felírás megtörtént.")
   elseif (result=='1') then
     ui:executeCommand("toast","Nincs elég készlet a helykódon az összes darab kiadásához!")
   
   else
     ui:executeCommand("toast","Felírási hiba történt!")
   end
   ui:executeCommand("hideobj","cikkkltpanel")
   ui:executeCommand("showobj","pfooter")
   ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', azon..' . . 1')
else
   ui:executeCommand("toast","Ezen a helykódon nincs készlet!")
end


    
