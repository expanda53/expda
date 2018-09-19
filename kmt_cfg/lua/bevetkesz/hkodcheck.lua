--<verzio>20180911</verzio>
require '.egyeb.functions'
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
hkod = params[2]:gsub("n",""):gsub(':',''):gsub("%%20"," ")
if (hkod:len()<=10) then
    --hkod ellenorzes
    ahkod=hkod
    hkod = hkod:gsub(" ","%%20")
    str = 'hkod_check '..hkod
    t=luafunc.query_assoc(str,false)
    result=t[1]['RESULT']
else
    result='-11'
end

if (result=='0') then
  ui:executeCommand('aktbcodeobj','bcode_cikk','')
  ui:executeCommand('disabled','ehkod','')
  ui:executeCommand('setbgcolor','ehkod','#434343')

  ui:executeCommand('showobj','cap_cikod;ecikod;button_ujhkod','')
  ui:executeCommand('setfocus','ecikod','')   
else
 if (result=='-11') then
    msg = 'A helykód hossza max 10 karakter lehet!'    
 else
    msg = 'Nem található a rendszerben ilyen helykód:\n'
 end
 alert(ui,msg..ahkod)

 ui:executeCommand('valueto','ehkod','')
 ui:executeCommand('setfocus','ehkod','')   
end

