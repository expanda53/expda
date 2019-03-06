--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
lotthkod = params[2]:gsub("\n",""):gsub(':','')
varthkod = params[3]:gsub("\n",""):gsub(':','')
--hkod ellenorzes
if (lotthkod==varthkod) then
  ui:executeCommand('aktbcodeobj','bcode2','')
  ui:executeCommand('disabled','ehkod','')
  ui:executeCommand('setbgcolor','ehkod','#434343')
  ui:executeCommand('showobj','cap_ean;eean;lcikknev;button_kovetkezo','')
  ui:executeCommand('valueto','eean','')
  ui:executeCommand('setfocus','eean','')
else
 alert(ui,'Nem egyezik a várt és a lőtt helykód!')
 ui:executeCommand('valueto','ehkod','')
 ui:executeCommand('setfocus','ehkod','')   
end

