--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
cikk = params[2]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'keszrejel_cikkcheck '..cikk
t=luafunc.query_assoc(str,false)
cikknev=t[1]['CIKKNEV']
result=t[1]['RESULT']
if (result=='0') then
    ui:executeCommand('valueto','lcikknev',cikknev)
    ui:executeCommand('showobj','cap_drb;button_ujcikk','')
    ui:executeCommand('valueto','edrb','')
    ui:executeCommand('setfocus','edrb','') 
    
elseif (result=='-1') then
 
 alert(ui,'Nem található termék:\n'.. cikk)
 ui:executeCommand('valueto','ecikod','')
 ui:executeCommand('setfocus','ecikod','') 
end

