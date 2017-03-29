--<verzio>20170329</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ean = params[2]:gsub("\n",""):gsub(':','')
acikod = params[3]:gsub("\n",""):gsub(':','')
fejazon = params[4]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
str = 'ellenor_eankeres ' .. fejazon .. ' ' ..  ean .. ' ' .. acikod .. ' ' .. kezelo .. ' ' .. kulsoraktar
--ean=. ha a cikk kódra keresünk 
if (ean=='.') then
  ean = acikod
end
t=luafunc.query_assoc(str,false)
cikkval=0
result=t[1]['RESULT']
cikk=t[1]['CIKK']
cikknev=t[1]['CIKKNEV']
drb2=t[1]['DRB2']
drb=t[1]['DRB']
if (result=='0') then
  ui:executeCommand('valueto','ldrb',drb)
  
  if (drb2=='0') then drb2='' end
  ui:executeCommand('valueto','ldrb2',drb2)
  ui:executeCommand('valueto','edrb2','')
  ui:executeCommand('valuetohidden','lcikod',cikk)
  ui:executeCommand('valueto','lcikknev',cikknev)
  ui:executeCommand('showobj','cap_drb;cap_drb2;cap_edrb2;button_ujean','')
  ui:executeCommand('setfocus','edrb2','') 
elseif (result=='1') then
  cikkval=0
  alert(ui,'Nem található ilyen termék a bizonylaton:\n'..cikknev)
  ui:executeCommand('valueto','eean','') 
  
elseif (result=='2') then
  cikkval=0
  alert(ui,'Több van átvéve, mint a rendelt:\n'..'Rendelt:' .. drb .. ' Átvéve:'..drb2)
  ui:executeCommand('valueto','eean','') 
elseif (result=='-1') then
  cikkval=1
  alert(ui,'Nem található termék ilyen ean kóddal:\n'..ean)
  ui:executeCommand('valueto','eean','') 
elseif (result=='-2') then
  cikkval=2
  alert(ui,'Több termék is található termék ilyen ean kóddal:\n'..ean)
  ui:executeCommand('valueto','eean','') 
end


--ui:executeCommand('scanneron','','')

if (cikkval>0) then
    if (cikkval==1) then
      ean='.'
    end
    ui:executeCommand("startlua","egyeb/cikkval_open.lua",ean)
end

