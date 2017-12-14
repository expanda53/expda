--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ean = params[2]:gsub("n",""):gsub(':','')
fejazon = params[3]:gsub("n",""):gsub(':','')
hkod = params[4]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'leltar_ean_check '..ean..' ' .. fejazon .. ' ' .. hkod .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
cikknev=t[1]['CIKKNEV']
kod=t[1]['CIKK']
result=t[1]['RESULT']
--drb=t[1]['DRB']
cikkval=0;
if (result=='0') then
    ui:executeCommand('valueto','lcikknev',cikknev)
    ui:executeCommand('valuetohidden','lcikod',kod)
    ui:executeCommand('showobj','cap_dot;button_ujean','')
    --if (drb=='0') then
    --  drb=''
    --end
    ui:executeCommand('valueto','edot','')
    ui:executeCommand('setfocus','edot','') 
elseif (result=='-1') then
 alert(ui,'Nem található termék ilyen ean kóddal:\n'..ean)
end
