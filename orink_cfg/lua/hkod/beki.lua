--<verzio>20161219</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
szorzo = tostring(ui:findObject('lszorzo'):getText())
if (szorzo=='-1') then
  szorzo='1'
  caption='Betárolás'
  bgcolor='#7A9D96'
else
  szorzo='-1'
  caption='Kiszedés'
  bgcolor='#497000'
end
ui:executeCommand('valueto','button_kibe',caption)
ui:executeCommand('valuetohidden','lszorzo',szorzo)
ui:executeCommand('startlua','hkod/ujhkod.lua','')
ui:executeCommand('setbgcolor','ehkod;button_kibe;eean;edrb',bgcolor)
ui:executeCommand("hideobj","hkodkltpanel;cikkkltpanel;cikkvalpanel")
--drbvis = tostring(ui:findObject('edrb'):getVisibility())
--if (drbvis ~= '4') then
--  ui:executeCommand('show','cap_maxdrb;lmaxdrb','')
--end
--4 hidden

