--<verzio>20180118</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
fejazon = params[2]:gsub("n",""):gsub(':','')
hkod = params[3]:gsub("n",""):gsub(':','')
cikk = params[4]:gsub("n",""):gsub(':','')
irany = params[5]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")

--kov/elozo kiadhato sor
str = 'kiadas_kovsor '..fejazon..' '..hkod..' ' ..cikk..' '..irany..' '..kezelo
t=luafunc.query_assoc(str,false)
result = t[1]['RESULT']
if (result=='0') then
    ujhkod=t[1]['HKOD']
    if (ujhkod=='HKODVAR') then
      --ha a helykod 'HKODVAR' akkor kezzel valaszt helykodot a helykod listabol.
      --ekkor lathatja a cikk adatokat is (egyeb helykodnal csak a helykod lelovese utan)
      --valasztas utan a kivalasztott helykod felirodik a bizonylat sorara. Ha a megadott helykodon nincs eleg drb, akkor megbontja a sort
    cikod = t[1]['CIKK']
    ui:executeCommand('hide','pfooter','')
    str = 'hkod_cikkklt '..cikod..' '.. kulsoraktar
    list=luafunc.query_assoc_to_str(str,false)
    luafunc.refreshtable_fromstring('cikkklt_table',list)
    if (list~=nil) then
       ui:executeCommand('valuetohidden','ehkod', '')
       ui:executeCommand('valuetohidden','lhkod', '')
       ui:executeCommand('aktbcodeobj','bcode1','')          
       ui:executeCommand('valuetohidden','lmegys', t[1]['MEGYS'])
       ui:executeCommand('valuetohidden','lcikknev', t[1]['CIKKNEV'])
       ui:executeCommand('valuetohidden','lcikod', t[1]['CIKK'])
       ui:executeCommand('hideobj','cap_hkod;cap_drb;cap_drb2;cap_edrb2;cap_ean;eean;button_nincsmeg;button_kovetkezo;ldrb;ldrb2;edrb2','')      
       luafunc.refreshtable_fromstring('cikkklt_table',list)
       ui:executeCommand('show','cikkklt_table','')
    else
       ui:executeCommand('hide','cikkklt_table','')
    end

    cikknev = t[1]['CIKKNEV']
    ui:executeCommand("valueto","lcikknevp",cikknev)
    ui:executeCommand("showobj","cikkkltpanel")

      
    else 
        akthkod = tostring(ui:findObject('ehkod'):getText())
        if (ujhkod~=hkod or ujhkod~=akthkod) then
          --uj helykod kulonbozik
          ui:executeCommand('enabled','ehkod','')
          ui:executeCommand('setbgcolor','ehkod','#497000')
          ui:executeCommand('showobj','cap_hkod','')
          ui:executeCommand('valueto','ehkod', '')
          ui:executeCommand('valueto','lhkod', t[1]['HKOD'])
          ui:executeCommand('valuetohidden','lmegys', t[1]['MEGYS'])
          ui:executeCommand('valuetohidden','lcikknev', t[1]['CIKKNEV'])
          ui:executeCommand('valuetohidden','lcikod', t[1]['CIKK'])
          ui:executeCommand('valuetohidden','eean', '')
          ui:executeCommand('aktbcodeobj','bcode1','')
          ui:executeCommand('hideobj','cap_drb;cap_drb2;cap_edrb2;cap_ean;eean;button_nincsmeg;button_kovetkezo','')      
          ui:executeCommand('setfocus','ehkod','')      
        else
          ui:executeCommand('valueto','lmegys', t[1]['MEGYS'])
          ui:executeCommand('valueto','lcikknev', t[1]['CIKKNEV'])
          ui:executeCommand('valueto','lcikod', t[1]['CIKK'])
          ui:executeCommand('valueto','eean', '')
          ui:executeCommand('hideobj','cap_drb;cap_drb2;cap_edrb2','')      
          ui:executeCommand('setfocus','eean','')      
        end

        ui:executeCommand('valuetohidden','ldrb', t[1]['DRB'])
        ui:executeCommand('valuetohidden','ldrb2', t[1]['DRB2'])
        ui:executeCommand('valuetohidden','edrb2', '')
    end

    
else
  if (result~='-1') then
    if (irany=='1') then
        if (cikk=='.') then
            ui:executeCommand('valuetohidden','ehkod','')
            ui:executeCommand('valuetohidden','edrb2','')
            ui:executeCommand('valuetohidden','ldrb','')
            ui:executeCommand('valuetohidden','ldrb2','')
            ui:executeCommand('valueto','lcikknev', 'Nincs több szedhető tétel!')
            ui:executeCommand('valuetohidden','lcikod', '')
            ui:executeCommand('valuetohidden','eean', '')
            ui:executeCommand('hideobj','cap_drb;cap_drb2;cap_edrb2;cap_hkod;lhkod;cap_ean;cap_megys;lmegys','')      
            ui:executeCommand('toast','Nincs több kiszedendő tétel!','')
            ui:executeCommand('startlua','kiadas/showreview.lua','')
        else
          ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', fejazon..' . . 1')
        end
    elseif (irany=='0') then
        if (result=='2') then
          ui:executeCommand('toast','Nincs ilyen kiszedendő tétel!','')
          ui:executeCommand('startlua','kiadas/showreview.lua','')
        end
    elseif (irany=='-1') then
        ui:executeCommand('toast','Nincs előző kiszedendő tétel!','')
    end
  else
    ui:executeCommand('toast','Adatbázis hiba!','')
  end
end
--luafunc.log(str)
