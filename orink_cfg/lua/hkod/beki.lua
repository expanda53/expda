--<verzio>20161123</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
szorzo = params[2]:gsub("n",""):gsub(':','')
ui:executeCommand('valuetohidden','lszorzo',szorzo)
--ui:executeCommand('hide','cap_drb;edrb;cap_ean;eean;button_ujhkod;button_ujean;reviewpanel;cikkvalpanel;button_cikkval','')
ui:executeCommand('showobj','cap_hkod;ehkod','')
--ui:executeCommand('setfocus','ehkod','')
if (szorzo=='-1') then
    --kiadasra valt
    ui:executeCommand('setbgcolor','button_be','#d4d4dc')
    ui:executeCommand('setbgcolor','button_ki','#FF7F50')
    ui:executeCommand('setfontcolor','button_be','#8e8e90')
    ui:executeCommand('setfontcolor','button_ki','#000000')
    drbvis = tostring(ui:findObject('edrb'):getVisibility())
    if (drbvis ~= '4') then
      ui:executeCommand('show','cap_maxdrb;lmaxdrb','')
    end
    --4 hidden
    
    
else
--bevetre valt
    ui:executeCommand('setbgcolor','button_ki','#d4d4dc')
    ui:executeCommand('setbgcolor','button_be','#FF7F50')
    ui:executeCommand('setfontcolor','button_ki','#8e8e90')
    ui:executeCommand('setfontcolor','button_be','#000000')
    ui:executeCommand('hide','cap_maxdrb;lmaxdrb','')
end
