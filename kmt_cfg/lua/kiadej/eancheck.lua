--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
cikk = params[2]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()

str = 'kiadej_cikkcheck ' ..  cikk 

t=luafunc.query_assoc(str,false)
cikkval=0
result=t[1]['RESULT']
cikknev=t[1]['CIKKNEV']
if (result=='0') then
  ui:executeCommand('valueto','edrb2','')
  ui:executeCommand('valueto','lcikknev',cikk .. ' ' ..cikknev)
  ui:executeCommand('showobj','cap_edrb2;button_ujcikk','')
  ui:executeCommand('setfocus','edrb2','') 
else 
      alert(ui,'Nem található ilyen cikk a rendszerben!' .. cikk)
      ui:executeCommand('valueto','eean','') 
      ui:executeCommand('setfocus','eean','') 
end

