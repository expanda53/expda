--<verzio>20161123</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
szorzo = tostring(ui:findObject('lszorzo'):getText())
if (szorzo=='-1') then
  szorzo='1'
  caption='Berakás'
else
  szorzo='-1'
  caption='Kiszedés'
end
ui:executeCommand('valueto','button_kibe',caption)
ui:executeCommand('valuetohidden','lszorzo',szorzo)
if (szorzo=='-1') then
    --kiadasra valt
    drbvis = tostring(ui:findObject('edrb'):getVisibility())
    ui:executeCommand('setbgcolor','button_kibe;ehkod;eean;edrb','#497000')
    if (drbvis ~= '4') then
      ui:executeCommand('show','cap_maxdrb;lmaxdrb','')
    end
    --4 hidden
else
--bevetre valt
    ui:executeCommand('hide','cap_maxdrb;lmaxdrb','')
    ui:executeCommand('setbgcolor','button_kibe;ehkod;eean;edrb','#7A9D96')
end