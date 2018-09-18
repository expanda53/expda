--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
fejazon = params[2]:gsub("\n",""):gsub(':','')
lot = params[3]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()

str = 'beerk_lotkeres ' .. fejazon .. ' ' ..  lot .. ' ' .. kezelo 

t=luafunc.query_assoc(str,false)
cikkval=0
result=t[1]['RESULT']
cikk=t[1]['CIKK']
cikknev=t[1]['CIKKNEV']
drb=t[1]['DRB']
if (result=='0') then
  ui:executeCommand('valueto','edrb',drb)
  ui:executeCommand('valueto','lmaxdrb',drb)
  ui:executeCommand('valuetohidden','lcikod',cikk)
  ui:executeCommand('valueto','lcikknev','[' .. cikk .. '] ' ..cikknev)
  ui:executeCommand('showobj','cap_drb;cap_maxdrb;button_ujlot','')
  ui:executeCommand('setfocus','edrb','') 

elseif (result=='-1') then
  cikkval=0
  alert(ui,'Nem található ilyen termék a beérkezésen:\n'..cikknev)
  ui:executeCommand('valueto','elot','') 
elseif (result=='-2') then
  cikkval=2
  alert(ui,'Több termék is található ilyen lot számmal:\n'..lot)
  ui:executeCommand('valueto','elot','') 
else  
  alert(ui,'Egyéb hiba történt:\n'..lot)
end

