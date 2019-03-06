--<verzio>20161130</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('aktbcodeobj','bcode0','')
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valuetohidden','eean','')
ui:executeCommand('valueto','ehkod','')
ui:executeCommand('hide','cap_drb;edrb;cap_ean;eean;button_cikkklt;button_ujhkod;button_ujean;cikkvalpanel;button_cikkval;cap_maxdrb;lmaxdrb','')
szorzo = tostring(ui:findObject('lszorzo'):getText())
if (szorzo=='-1') then
    --kiadasra valt
    ui:executeCommand('setbgcolor','ehkod','#497000')
    --4 hidden
else
--bevetre valt
    ui:executeCommand('setbgcolor','ehkod','#7A9D96')
end
ui:executeCommand('enabled','ehkod','')
ui:executeCommand('setfocus','ehkod','')



