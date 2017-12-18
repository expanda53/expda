--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
    
fejazon = tostring(ui:findObject('lfejazon'):getText()):gsub("n",""):gsub(':','')
cikk = tostring(ui:findObject('lcikod'):getText()):gsub("n",""):gsub(':','')
hkod = tostring(ui:findObject('ehkod'):getText()):gsub("n",""):gsub(':','')
dot = tostring(ui:findObject('edot'):getText()):gsub("n",""):gsub(':','')
ean = tostring(ui:findObject('eean'):getText()):gsub("n",""):gsub(':','')
drb = tostring(ui:findObject('edrb'):getText()):gsub("n",""):gsub(':','')
drb2 = tostring(ui:findObject('cap_rdrb'):getText()):gsub("n",""):gsub(':','')

if (#params>1) then
  dialogres = params[2]:gsub("\n",""):gsub(':','')
else
  dialogres="null"
end  

if (drb2=='') then
  drb2='0'
end

if (dialogres=="null") then
    if (tonumber(drb2)~=0) then
      ui:showDialog("Van már ilyen tétel a leltárban.\n\nNem: Hozzáadja\nIgen: Felülírja","leltar/mentes.lua felulir","leltar/mentes.lua sum")
    else
      dialogres = "felulir"
    end
end

if (dialogres~="null") then
    if (dialogres=="sum") then
        --hozzaadas
        drb = tonumber(drb2) + tonumber(drb)
    end
    if (tonumber(drb)>0) then
        kezelo = ui:getKezelo()
        uzmod=ui:getGlobal("uzmod")
        str = 'leltar_ment ' .. fejazon .. ' ' .. hkod .. ' ' .. cikk .. ' ' .. ean .. ' ' .. drb .. ' ' .. dot .. ' ' ..kezelo .. ' ' .. uzmod
        t=luafunc.query_assoc(str,false)
        result = t[1]['RESULT']
        resulttext = t[1]['RESULTTEXT']
        if (result=='0') then
            ui:executeCommand('TOAST','Mentés rendben.')
        else
            --ui:executeCommand('TOAST','Hiba:' .. resulttext)
            alert(ui,"")
            ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
        end
        ui:executeCommand('hideobj','cap_drb;edrb;button_ujean;lcikknev;cap_rdrb;cap_dot;edot','')
        ui:executeCommand('setfocus','eean', '')
        ui:executeCommand('valueto','eean', '')
    else
        alert(ui,'Mennyiség nem lehet nulla!')
        ui:executeCommand('valueto','edrb','')
        ui:executeCommand('setfocus','edrb', '')

    end
end    

