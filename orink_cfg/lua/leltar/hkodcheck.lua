--<verzio>20161117</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
hkod = params[2]:gsub("n",""):gsub(':','')
--hkod ellenorzes
str = 'hkod_check '..hkod
t=luafunc.query_assoc(str,false)
result=t[1]['RESULT']
if (result=='0') then
  ui:executeCommand('aktbcodeobj','bcode2','')
  ui:executeCommand('showobj','cap_ean;eean;button_ujhkod','')
else
 ui:executeCommand('setfocus','ehkod','') 
 ui:executeCommand('toast','Nem található a rendszerben ilyen helykód:\n'..hkod)
 ui:executeCommand('valueto','ehkod','')

end

