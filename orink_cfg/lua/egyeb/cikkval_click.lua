--<verzio>20170105</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
    
function cikkUpdate(kod,nev)    
  ui:executeCommand('toast','Választott cikk:\n[' .. kod  .. '] ' .. nev,2)
  ui:executeCommand('valueto','lcikknev',nev)
  ui:executeCommand('valuetohidden','lcikod',kod)
end

row = ui:findObject('cikkval_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
kod= t['KOD']
nev= t['NEV']
ui:executeCommand('hide','cikkvalpanel','')
kulsoraktar = ui:getGlobal("kulsoraktar")
aktmodul = tostring(ui:findObject('lmodulstat'):getText())
if (aktmodul == 'Beérkezés') then
  cegazon = tostring(ui:findObject('lcegazon'):getText())
  --cikkUpdate(kod,nev)
  --ui:executeCommand('showobj','cap_drb;ldrb;cap_drb2;edrb2;button_ujean','')
  --ui:executeCommand('valueto','ldrb','0') 
  --ui:executeCommand('valueto','edrb2','') 
  --ui:executeCommand('setfocus','edrb2','') 
    ui:executeCommand('startlua','bevet/bcode1.lua','. ' .. kod .. ' ' .. cegazon)
elseif (aktmodul=='Leltár') then
  cikkUpdate(kod,nev)
  ui:executeCommand('showobj','cap_drb;edrb;button_ujean','')
  ui:executeCommand('valueto','edrb','') 
  ui:executeCommand('setfocus','edrb','') 
elseif (aktmodul=='Kiadás') then
  cikod = tostring(ui:findObject('lcikod'):getText())
  if (cikod==kod) then
      ui:executeCommand('showobj','cap_drb;ldrb;cap_drb2;ldrb2;cap_edrb2;edrb2','')
      ui:executeCommand('setfocus','edrb2','') 
  else 
      alert(ui,'Nem egyezik a várt és a kiválasztott cikk!')
      ui:executeCommand('valueto','eean','') 
      ui:executeCommand('setfocus','eean','') 
  end
elseif (aktmodul=='Hkód rendezés') then
  cikkUpdate(kod,nev)
  ui:executeCommand('showobj','cap_drb;edrb;button_ujean;button_cikkklt','')
  ui:executeCommand('valueto','edrb','') 

  szorzo = tostring(ui:findObject('lszorzo'):getText())
  hkod = tostring(ui:findObject('ehkod'):getText())
  azon = tostring(ui:findObject('lfejazon'):getText())
  str = 'hkod_cikkhkklt '..hkod..' '..kod.. ' ' .. kulsoraktar
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
  ui:executeCommand('setfocus','edrb','') 
end
ui:executeCommand('showobj','pfooter','')
