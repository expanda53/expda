--<verzio>20161117</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ean = params[2]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'ean_check '..ean
t=luafunc.query_assoc(str,false)
cikknev=t[1]['CIKKNEV']
kod=t[1]['CIKK']
result=t[1]['RESULT']
if (result=='0') then
    ui:executeCommand('valueto','lcikknev',cikknev)
    ui:executeCommand('valuetohidden','lcikod',kod)
    ui:executeCommand('aktbcodeobj','bcode2','')
    ui:executeCommand('showobj','cap_drb;edrb;button_ujean','')
elseif (result=='-1') then
 ui:executeCommand('setfocus','eean','') 
 ui:executeCommand('toast','Nem található termék ilyen ean kóddal:\n'..ean)
 ui:executeCommand('valueto','eean','')
elseif (result=='-2') then
 ui:executeCommand('setfocus','eean','') 
 ui:executeCommand('toast','Több termék is található termék ilyen ean kóddal:\n'..ean)
 ui:executeCommand('valueto','eean','')
end
