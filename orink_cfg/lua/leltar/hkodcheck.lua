--<verzio>20161223</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
hkod = params[2]:gsub("n",""):gsub(':','')
--hkod ellenorzes
str = 'hkod_check '..hkod
t=luafunc.query_assoc(str,false)
result=t[1]['RESULT']
if (result=='0') then
  ui:executeCommand('aktbcodeobj','bcode1','')
  ui:executeCommand('showobj','cap_ean;eean;button_ujhkod;button_cikkval','')
  ui:executeCommand('disabled','ehkod','')
  ui:executeCommand('setbgcolor','ehkod','#434343')
  
else
 ui:executeCommand('setfocus','ehkod','') 
 alert(ui,'Nem található a rendszerben ilyen helykód:\n'..hkod)
 ui:executeCommand('valueto','ehkod','')

end

