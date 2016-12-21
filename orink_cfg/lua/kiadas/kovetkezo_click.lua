--<verzio>20161219a</verzio>
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
    ujhkod=t[1]['HKOD']
    if (ujhkod~=hkod) then
      --uj helykod kulonbozik
      ui:executeCommand('enabled','ehkod','')
      ui:executeCommand('setbgcolor','ehkod','#497000')
      ui:executeCommand('showobj','cap_hkod','')
      ui:executeCommand('valueto','ehkod', '')
      ui:executeCommand('valueto','lhkod', t[1]['HKOD'])
      ui:executeCommand('valuetohidden','lcikknev', t[1]['CIKKNEV'])
      ui:executeCommand('valuetohidden','lcikod', t[1]['CIKK'])
      ui:executeCommand('valuetohidden','eean', '')
      ui:executeCommand('aktbcodeobj','bcode1','')
      ui:executeCommand('hideobj','cap_drb;cap_drb2;cap_edrb2;cap_ean;eean;button_nincsmeg','')      
      ui:executeCommand('setfocus','ehkod','')      
    else
      ui:executeCommand('valueto','lcikknev', t[1]['CIKKNEV'])
      ui:executeCommand('valueto','lcikod', t[1]['CIKK'])
      ui:executeCommand('valueto','eean', '')
      ui:executeCommand('hideobj','cap_drb;cap_drb2;cap_edrb2','')      
      ui:executeCommand('setfocus','eean','')      
    end

    ui:executeCommand('valuetohidden','ldrb', t[1]['DRB'])
    ui:executeCommand('valuetohidden','ldrb2', t[1]['DRB2'])
    ui:executeCommand('valuetohidden','edrb2', '')

    
else
    if (irany=='1') then 
        ui:executeCommand('valuetohidden','ehkod','')
        ui:executeCommand('valuetohidden','edrb2','')
        ui:executeCommand('valuetohidden','ldrb','')
        ui:executeCommand('valuetohidden','ldrb2','')
        ui:executeCommand('valueto','lcikknev', 'Nincs több szedhető tétel!')
        ui:executeCommand('valuetohidden','lcikod', '')
        ui:executeCommand('hideobj','cap_drb;cap_drb2;cap_edrb2;cap_hkod;lhkod','')      

        ui:executeCommand('toast','Nincs több kiszedendő tétel!','')
        ui:executeCommand('startlua','kiadas/showreview.lua','')
    else
        ui:executeCommand('toast','Nincs előző kiszedendő tétel!','')
    end
end
--luafunc.log(str)
