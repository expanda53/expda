--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
uzmod=ui:getGlobal("uzmod")
--atnezo panel
azon = tostring(ui:findObject('lfejazon'):getText())
hkod = tostring(ui:findObject('ehkod'):getText())
str = 'leltar_review ' .. hkod ..' '..kezelo..' '..azon ..' ' .. uzmod
list=luafunc.query_assoc_to_str(str,false)
if (list~=nil) then
   luafunc.refreshtable_fromstring('atnezo_table',list)
   ui:executeCommand('show','atnezo_table','')
   if (hkod~='') then
     ujhkod=1
   else
     ujhkod=0
   end
else
   ui:executeCommand('hide','atnezo_table','')
   ujhkod=0
end
ui:executeCommand("showobj","reviewpanel")

--ki lehet-e rakni az ujhkod gombot
if (ujhkod>0) then
    str = 'leltar_ujhkod_check ' .. azon .. ' ' .. hkod .. ' ' .. kezelo .. ' ' .. uzmod
    t=luafunc.query_assoc(str,false)
    result_hkod=t[1]['RESULT']

    hkod=''
    str = 'leltar_hkodlist_check ' .. azon .. ' ' .. kezelo .. ' ' .. uzmod
    t=luafunc.query_assoc(str,false)
    result_osszes=t[1]['RESULT']

else
  result_hkod=1;
  result_osszes=1;
end

if (tonumber(result_hkod)>0) then
    --van meg elteres, ami nincs megerositve, nem zarhato, nem mehet uj helykodra
    ui:executeCommand('hide','button_ujhkod','')
else
    ui:executeCommand('show','button_ujhkod','')
end

if (tonumber(result_osszes)>0) then
    --van meg elteres, ami nincs megerositve, nem zarhato, nem mehet uj helykodra
    ui:executeCommand('hide','btn_lezar','')
else
    ui:executeCommand('show','btn_lezar','')
end
