require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ean = params[2]:gsub("n",""):gsub(':','')
lean = params[3]:gsub("n",""):gsub(':','')
--lean2 = tostring(ui:findObject('lean'):getText())

if (ean == lean) then
  ui:executeCommand('showobj','cap_drb;ldrb;cap_drb2;ldrb2','')
else
  ui:executeCommand('uzenet','A belőtt és a várt EAN eltér!\nvárt:' .. lean .. '\nbelőtt:'..ean)
end
ui:executeCommand('aktbcodeobj','bcode2','')
--ui:executeCommand('scanneron','','')
