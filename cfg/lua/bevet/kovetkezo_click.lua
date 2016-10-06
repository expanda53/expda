require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
mibiz = params[2]:gsub("n",""):gsub(':','')
sorsz = params[3]:gsub("n",""):gsub(':','')
irany = params[4]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
--kov/elozo kiadhato sor
str = 'kiadas_kovsor '..kezelo..' '..mibiz..' ' ..sorsz..' '..irany
t=luafunc.query_assoc(str,false)

if (t[1]['SORSZ']>'0') then
    ui:executeCommand('valueto','lcikknev', t[1]['CIKKNEV'])
    ui:executeCommand('valueto','lean', t[1]['EAN'])
    ui:executeCommand('valuetohidden','lsorsz', t[1]['SORSZ'])
    ui:executeCommand('aktbcodeobj','bcode1','')
    --ui:executeCommand('showobj','eean;button_review;button_kovetkezo','')

    ui:executeCommand('valuetohidden','ldrb', t[1]['DRB'])
    ui:executeCommand('valuetohidden','ldrb2', t[1]['DRB2'])
    if (t[1]['DRB2']=='0') then
      ui:executeCommand('hideobj','button_gyszamlist', '')
    else
      ui:executeCommand('showobj','button_gyszamlist', '')
    end
    ui:executeCommand('setfocus','eean','')
    
else
    if (irany=='+') then 
        ui:executeCommand('uzenet','Nincs több kiszedendő tétel!','')
    else
        ui:executeCommand('uzenet','Nincs előző kiszedendő tétel!','')
    end
end
--luafunc.log(str)
