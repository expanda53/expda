--<verzio>20190301</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
fejazon = params[2]:gsub("\n",""):gsub(':','')
cikk = params[3]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()

str = 'bevetkesz_cikkcheck ' ..  cikk .. ' ' .. fejazon 

t=luafunc.query_assoc(str,false)
cikkval=0
result=t[1]['RESULT']
cikknev=t[1]['CIKKNEV']
drb=t[1]['DRB']
if (result=='0') then
  ui:executeCommand('valueto','edrb',drb)
  ui:executeCommand('valueto','lmaxdrb',drb)
  ui:executeCommand('valuetohidden','lcikod',cikk)
  ui:executeCommand('valueto','lcikknev','[' .. cikk .. '] ' ..cikknev)
  ui:executeCommand('showobj','cap_drb;cap_maxdrb;button_ujcikk','')
  ui:executeCommand('setfocus','edrb','') 

elseif (result=='-1') then
  alert(ui,'Nem található ilyen termék a bevét bizonylaton:\n' .. cikk .. ' ' .. cikknev)
  ui:executeCommand('valueto','ecikod','') 
else  
  alert(ui,'Egyéb hiba történt:\n'..cikk)
end

