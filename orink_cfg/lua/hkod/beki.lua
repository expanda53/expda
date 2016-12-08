--<verzio>20161208</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
szorzo = tostring(ui:findObject('lszorzo'):getText())
if (szorzo=='-1') then
  szorzo='1'
  caption='Betárolás'
else
  szorzo='-1'
  caption='Kiszedés'
end
hkod_enabled = ui:findObject('ehkod'):isEnabled()
ui:executeCommand('valueto','button_kibe',caption)
ui:executeCommand('valuetohidden','lszorzo',szorzo)


kod = tostring(ui:findObject('lcikod'):getText())
hkod = tostring(ui:findObject('ehkod'):getText())
if (kod~="") then
  azon = tostring(ui:findObject('lfejazon'):getText())
  str = 'hkod_cikkhkklt '..hkod..' '..kod
  t2=luafunc.query_assoc(str,false)
  maxkidrb=t2[1]['MAXKIDRB']

  str = 'hkod_kocsiklt '..azon..' '..kod
  t2=luafunc.query_assoc(str,false)
  maxbedrb=t2[1]['DRB']
  

  if (szorzo=='-1') then
      ui:executeCommand('valueto','lmaxdrb',maxkidrb)
      ui:executeCommand('showobj','cap_maxdrb','')
  else
      ui:executeCommand('valueto','lmaxdrb',maxbedrb)
      ui:executeCommand('showobj','cap_maxdrb','')
  end
  ui:executeCommand('valueto','edrb','')
end

if (szorzo=='-1') then
    --kiadasra valt
    --drbvis = tostring(ui:findObject('edrb'):getVisibility())
    ui:executeCommand('setbgcolor','button_kibe;eean;edrb','#497000')
    if (hkod_enabled) then
      ui:executeCommand('setbgcolor','ehkod','#497000')
    end
    --if (drbvis ~= '4') then
    --  ui:executeCommand('show','cap_maxdrb;lmaxdrb','')
    --end
    --4 hidden
else
--bevetre valt
    ui:executeCommand('setbgcolor','button_kibe;eean;edrb','#7A9D96')
    if (hkod_enabled) then
      ui:executeCommand('setbgcolor','ehkod','#7A9D96')
    end



end
