--<verzio>20180213</verzio>
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
    ui:executeCommand('showobj','pfooter','')
elseif (aktmodul=='Leltár') then
  --cikkUpdate(kod,nev)
  --ui:executeCommand('showobj','cap_drb;edrb;button_ujean','')
  --ui:executeCommand('valueto','edrb','') 
  --ui:executeCommand('setfocus','edrb','') 
  --ui:executeCommand('showobj','pfooter','')
  hkod = tostring(ui:findObject('ehkod'):getText())
  azon = tostring(ui:findObject('lfejazon'):getText())  
  ui:executeCommand('startlua','leltar/bcode1.lua','. ' .. kod..' '..azon.. ' '..hkod)
  ui:executeCommand('showobj','pfooter','')
  
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
  ui:executeCommand('showobj','pfooter','')
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
  aktbcodeobj = ui:getGlobal("aktbcodeobj")
  if (aktbcodeobj=='bcode1') then
    ui:executeCommand('setfocus','edrb','') 
    ui:executeCommand('showobj','pfooter','')
  else
    ui:executeCommand('startlua','hkod/cikkklt.lua',kod)
  end
elseif (aktmodul=='Beérkezés elrakodás') then
  cikkUpdate(kod,nev)

  ui:executeCommand('aktbcodeobj','bcode1','')
  ui:executeCommand('disabled','eean','')
  ui:executeCommand('setbgcolor','eean','#434343')
  ui:executeCommand('showobj','cap_hkod;ehkod;button_ujean;button_hkodlst;button_cikkklt','')
  ui:executeCommand('setfocus','ehkod','')
  ui:setGlobal("aktbcodeobj",'bcode1')  
  
  -- kiadhato keszlet mindig a B00000 hkod keszlete
  hkodbe='B00000'
  str = 'hkod_cikkhkklt ' .. hkodbe .. ' ' .. kod .. ' ' .. kulsoraktar
  t2=luafunc.query_assoc(str,false)
  maxkidrb=t2[1]['MAXKIDRB']

  ui:executeCommand('valueto','lmaxdrb',maxkidrb)
  ui:executeCommand('showobj','cap_maxdrb','')      
  
  ui:executeCommand('startlua','bevethkod/cikkklt.lua',kod)
  ui:executeCommand('startlua','bevethkod/ujhkod.lua',kod)    
elseif (aktmodul=='Költözés') then
  cikkUpdate(kod,nev)

  
  ui:executeCommand('disabled','eean','')
  ui:executeCommand('setbgcolor','eean','#434343')
  ui:executeCommand('showobj','cap_hkod;ehkod;button_ujean;button_cikkklt','')
  ui:executeCommand('aktbcodeobj','bcode1','')
  ui:setGlobal("aktbcodeobj",'bcode1')
  
  
  hkodbe = tostring(ui:findObject('ehkod'):getText())
  str = 'hkod_cikkhkklt ' .. hkodbe .. ' ' .. kod .. ' ' .. kulsoraktar
  t2=luafunc.query_assoc(str,false)
  maxkidrb=t2[1]['MAXKIDRB']

  ui:executeCommand('valueto','lmaxdrb',maxkidrb)
  ui:executeCommand('showobj','cap_maxdrb','')      
 
  ui:executeCommand('startlua','bevethkod/cikkklt.lua',kod)
  ui:executeCommand('enabled','ehkod','')
  ui:executeCommand('setbgcolor','ehkod','#497000')  
  ui:executeCommand('setfocus','ehkod','')  
elseif (aktmodul=='Spot leltár cikkre')  then
  cikkUpdate(kod,nev)
  ui:executeCommand('showobj','button_ujean;button_cikkklt','')
  ui:executeCommand('startlua','bevethkod/cikkklt.lua', kod)
elseif (aktmodul=='Spot leltár hkódra')  then
  cikkUpdate(kod,nev)
  ui:executeCommand('showobj','cap_drb','')
  ui:executeCommand('valueto','edrb','') 
  ui:executeCommand('setfocus','edrb','') 
  ui:executeCommand('showobj','pfooter','')
elseif (aktmodul=='Kiadás ellenőrzés')  then
  cikkUpdate(kod,nev)
  azon = tostring(ui:findObject('lfejazon'):getText())
  ui:executeCommand('startlua','ellenor/bcode1.lua','. ' .. kod .. ' ' .. azon)
  ui:executeCommand('showobj','pfooter','')
end



