--<verzio>20170725</verzio>
require '.egyeb.functions'
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
hkod = params[2]:gsub("n",""):gsub(':','')
kod = tostring(ui:findObject('lcikod'):getText())
--ui:executeCommand('startlua','bevethkod/hkodcheck.lua','')

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
  ui:executeCommand('startlua','bevethkod/hkodklt.lua',hkod)

  ui:executeCommand('showobj','cap_drb;edrb;button_ujhkod','')
  -- kiadhato keszlet mindig a B00000 hkod keszlete
  hkodbe='B00000'
  str = 'hkod_cikkhkklt ' .. hkodbe .. ' ' .. kod .. ' ' .. kulsoraktar
  t2=luafunc.query_assoc(str,false)
  maxkidrb=t2[1]['MAXKIDRB']

  ui:executeCommand('valueto','lmaxdrb',maxkidrb)
  ui:executeCommand('showobj','cap_maxdrb','')
  
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
 ui:setGlobal("aktbcodeobj",'bcode1')
 ui:executeCommand('valueto','ehkod_hkp','')
 ui:executeCommand('setfocus','ehkod_hkp','')   
 ui:executeCommand('hideobj','cap_drb;edrb','')
end

