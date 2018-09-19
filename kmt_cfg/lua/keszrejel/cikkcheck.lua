--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
cikk = params[2]:gsub("n",""):gsub(':','')
fejazon = params[3]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'keszrejel_cikkcheck '..cikk..' '..fejazon
t=luafunc.query_assoc(str,false)
cikknev=t[1]['CIKKNEV']
result=t[1]['RESULT']
drb=t[1]['DRB']
if (result=='0') then
    ui:executeCommand('valueto','lcikknev',cikknev)
    ui:executeCommand('valueto','ldrb2',drb)
    ui:executeCommand('showobj','cap_drb;cap_drb2;button_ujcikk','')
    ui:executeCommand('valueto','edrb','')
    ui:executeCommand('setfocus','edrb','') 
    
elseif (result=='-1') then
 
 alert(ui,'Nem található termék:\n'.. cikk)
 ui:executeCommand('valueto','ecikod','')
 ui:executeCommand('setfocus','ecikod','') 
end

