--<verzio>20180530</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ean = params[2]:gsub("\n",""):gsub(':','')
acikod = params[3]:gsub("\n",""):gsub(':','')
cegazon = params[4]:gsub("\n",""):gsub(':','')
if (#params>=5) then
  rentip = params[5]:gsub("\n",""):gsub(':','')
else
  rentip = tostring(ui:findObject('lrentip'):getText())
end  
if (rentip=='') then
  rentip='.'
end  
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
str = 'beerk_eankeres ' .. cegazon .. ' ' ..  ean .. ' ' .. acikod .. ' ' .. kezelo .. ' ' .. kulsoraktar .. ' ' .. rentip
--ean=. ha a cikk kódra keresünk 
if (ean=='.') then
  ean = acikod
end
t=luafunc.query_assoc(str,false)
cikkval=0
result=t[1]['RESULT']
cikk=t[1]['CIKK']
cikknev=t[1]['CIKKNEV']
drb3=t[1]['DRB3']
drb2=t[1]['DRB2']
drb=t[1]['DRB']
meret=t[1]['MERET']
suly=t[1]['SULY']
megys=t[1]['MEGYS']
if (result=='0') then
  ui:executeCommand('valueto','ldrb',t[1]['DRB'])
  
  if (drb2=='0') then drb2='' end
  ui:executeCommand('valueto','edrb2','')
  ui:executeCommand('valueto','ldrb3',drb3)
  ui:executeCommand('valueto','ldrb4',drb2)
  ui:executeCommand('valueto','lmeret',meret)
  ui:executeCommand('valueto','lsuly',suly)
  ui:executeCommand('valueto','lmegys',megys)
  ui:executeCommand('valuetohidden','lcikod',cikk)
  ui:executeCommand('valueto','lcikknev','[' .. cikk .. '] ' ..cikknev)
  ui:executeCommand('showobj','cap_drb;cap_drb2;cap_drb3;cap_drb4;button_ujean;cap_megys','')
  ui:executeCommand('setfocus','edrb2','') 
  bevmod = tostring(ui:findObject('lbevmod'):getText())
  if (bevmod=='auto') then
    --ui:executeCommand('valueto','edrb2','1')
    fejazon = tostring(ui:findObject('lfejazon'):getText())
    ui:executeCommand("startlua","bevet/mentes.lua",fejazon .. ' ' .. cegazon .. ' ' .. cikk .. ' ' .. ean .. ' ' .. '1' .. ' ' .. drb3 .. ' ' .. drb2 .. ' ' .. drb)
  end
elseif (result=='1') then
  cikkval=0
  alert(ui,'Nem található ilyen termék a rendeléseken:\n'..cikknev)
  ui:executeCommand('valueto','eean','') 
  
elseif (result=='2') then
  cikkval=0
  if (drb==drb2) then
    alert(ui,'A teljes rendelt mennyiség átvéve!\n'..'Átvéve:' .. drb )
  else
    alert(ui,'Több van átvéve, mint a rendelt:\n'..'Rendelt:' .. drb .. ' Átvéve:'..drb2)
  end
  ui:executeCommand('valueto','eean','') 
elseif (result=='-1') then
  cikkval=1
  alert(ui,'Nem található termék ilyen ean kóddal:\n'..ean)
elseif (result=='-2') then
  cikkval=2
  alert(ui,'Több termék is található termék ilyen ean kóddal:\n'..ean)
  ui:executeCommand('valueto','eean','') 
end


--ui:executeCommand('scanneron','','')

if (cikkval==1) then
    ui:executeCommand("startlua","bevet/cikkval_init.lua",'null')
end
if (cikkval==2) then
    ui:executeCommand("startlua","egyeb/cikkval_open.lua",ean)
end

