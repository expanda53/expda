require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
kezelo = ui:getKezelo()
azon = params[2]:gsub("n",""):gsub(':','')
hkod = params[3]:gsub("n",""):gsub(':','')
--hkod ellenorzes
str = 'leltar_hkod_check ' .. azon .. ' ' .. hkod .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
result=t[1]['RESULT']

if (result=='0') then
  ui:executeCommand('aktbcodeobj','bcode1','')
  ui:executeCommand('showobj','cap_ean;eean;button_emptyhkod','')
  ui:executeCommand('disabled','ehkod','')
  ui:executeCommand('setbgcolor','ehkod','#434343')
  ui:executeCommand('setfocus','eean','') 
else
 ui:executeCommand('setfocus','ehkod','') 
 if (result=='-2') then 
    msg = 'Ezt a helykódot nem kell ellenőrizni:\n'
 else
    msg = 'Nem található a rendszerben ilyen helykód:\n'
 end
 alert(ui,msg..hkod)
 ui:executeCommand('valueto','ehkod','')

end
