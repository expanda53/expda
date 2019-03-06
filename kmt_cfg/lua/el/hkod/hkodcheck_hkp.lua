--<verzio>20170223</verzio>
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
  ui:executeCommand('valueto','ehkod',hkod)
  ui:executeCommand('disabled','ehkod','')
  ui:executeCommand('setbgcolor','ehkod','#434343')
  ui:executeCommand('showobj','cap_ean;eean;button_ujhkod;button_cikkval','')
  ui:executeCommand('startlua','hkod/hkodklt.lua',hkod)
  ui:executeCommand('startlua','hkod/ujean.lua','')
  ui:setGlobal("aktbcodeobj",'bcode1')
else
 if (result=='-2') then 
    msg = 'Téves raktár választás, ebben a raktárban nem található ilyen helykód:\n'
 elseif (result=='-11') then
    msg = 'A helykód hossza max 10 karakter lehet!'    
 else
    msg = 'Nem található a rendszerben ilyen helykód:\n'
 end
 alert(ui,msg..hkod)
 --ui:executeCommand('startlua','hkod/ujhkod.lua','')
 ui:setGlobal("aktbcodeobj",'bcode0')
 ui:executeCommand('valueto','ehkod_hkp','')
 ui:executeCommand('setfocus','ehkod_hkp','')   
end

