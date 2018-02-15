--<verzio>20180213</verzio>
require '.egyeb.functions'
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
hkod = params[2]:gsub("n",""):gsub(':','')
if (hkod:len()<=10) then
    kulsoraktar = ui:getGlobal("kulsoraktar")
    --hkod ellenorzes
    str = 'hkod_check '..hkod..' '..kulsoraktar
    t=luafunc.query_assoc(str,false)
    result=t[1]['RESULT']
else
    result='-11'
end
if (result=='0') then
  kezelo = ui:getKezelo()
  str = 'bevetkolt_init '..hkod..' ' ..kezelo
  t=luafunc.query_assoc(str,false)
  azon=t[1]['AZON']
  mibiz=t[1]['MIBIZ']
  if (azon~='0') then
    ui:executeCommand('valueto','lmibiz', mibiz)
    ui:executeCommand('valueto','lfejazon', azon)  
  end

  ui:executeCommand('disabled','ehkregi','')
  ui:executeCommand('setbgcolor','ehkregi','#434343')
  ui:executeCommand('aktbcodeobj','bcode_ean','')
  ui:setGlobal("aktbcodeobj",'bcode_ean')
  
  ui:executeCommand('showobj','cap_ean;eean;button_hkodlst;button_cikkval','')
  ui:executeCommand('setfocus','eean','')   
else
 if (result=='-2') then 
    msg = 'Téves raktár választás, ebben a raktárban nem található ilyen helykód:\n'
 elseif (result=='-11') then
    msg = 'A helykód hossza max 10 karakter lehet!'    
 else
    msg = 'Nem található a rendszerben ilyen helykód:\n'
 end
 alert(ui,msg..hkod)

 ui:executeCommand('valueto','ehkregi','')
 ui:executeCommand('setfocus','ehkregi','')   
end

