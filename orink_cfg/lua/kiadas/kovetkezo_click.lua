--<verzio>20161101</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
fejazon = params[2]:gsub("n",""):gsub(':','')
hkod = params[3]:gsub("n",""):gsub(':','')
cikk = params[4]:gsub("n",""):gsub(':','')
irany = params[5]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
--kov/elozo kiadhato sor
str = 'kiadas_kovsor '..fejazon..' '..hkod..' ' ..cikk..' '..irany..' '..kezelo
t=luafunc.query_assoc(str,false)
result = t[1]['RESULT']
if (result=='0') then
    ui:executeCommand('valueto','lcikknev', t[1]['CIKKNEV'])
    ui:executeCommand('valuetohidden','lcikod', t[1]['CIKK'])
    ui:executeCommand('aktbcodeobj','bcode1','')
    --ui:executeCommand('showobj','eean;button_review;button_kovetkezo','')

    ui:executeCommand('valuetohidden','ldrb', t[1]['DRB'])
    ui:executeCommand('valuetohidden','ldrb2', t[1]['DRB2'])
    ui:executeCommand('setfocus','eean','')
    
else
    if (irany=='1') then 
        ui:executeCommand('uzenet','Nincs több kiszedendő tétel!','')
    else
        ui:executeCommand('uzenet','Nincs előző kiszedendő tétel!','')
    end
end
--luafunc.log(str)
