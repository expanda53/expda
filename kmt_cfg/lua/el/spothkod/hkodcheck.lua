--<verzio>20170221</verzio>
require '.egyeb.functions'
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
hkod = params[2]:gsub("n",""):gsub(':','')
if (hkod:len()<=10) then
    kulsoraktar = ui:getGlobal("kulsoraktar")
    kezelo = ui:getKezelo()
    ui:executeCommand("showprogress","Megnyitás...","")
    --hkod ellenorzes
    str = 'spothkod_check '..hkod..' '..kezelo..' '..kulsoraktar
    t=luafunc.query_assoc(str,false)
    result=t[1]['RESULT']
    resulttext=t[1]['RESULTTEXT']
    azon=t[1]['AZON']
    mibiz= t[1]['MIBIZ']
else
    result='-11'
end
if (result=='0' or result=='1') then
  ui:executeCommand('aktbcodeobj','bcode2','')
  ui:executeCommand('disabled','ehkod','')
  ui:executeCommand('setbgcolor','ehkod','#434343')
  ui:executeCommand('showobj','cap_ean;button_cikkval','')
  ui:executeCommand('valueto','eean','')
  ui:executeCommand('setfocus','eean','')
  ui:executeCommand('valuetohidden','lfejazon', azon)
  ui:executeCommand('valueto','lmibiz', mibiz)
  if (resulttext~='') then
    alert(ui,resulttext)
  end
else
 if (result=='-2') then 
    msg = 'Téves raktár választás, ebben a raktárban nem található ilyen helykód:\n'..hkod
 elseif (result=='-1') then
    msg = 'Nem található a rendszerben ilyen helykód:\n'..hkod
 elseif (result=='-11') then
    msg = 'A helykód hossza max 10 karakter lehet!'
 else 
    msg = resulttext
 end
 alert(ui,msg)

 ui:executeCommand('valueto','ehkod','')
 ui:executeCommand('setfocus','ehkod','')   
end
ui:executeCommand("hideprogress","","")
