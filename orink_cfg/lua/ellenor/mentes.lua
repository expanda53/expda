--<verzio>20170105</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
fejazon = params[2]:gsub("\n",""):gsub(':','')
cegazon = params[3]:gsub("\n",""):gsub(':','')
cikk = params[4]:gsub("\n",""):gsub(':','')
ean = params[5]:gsub("\n",""):gsub(':','')
drb2 = params[6]:gsub("\n",""):gsub(':','')
drb3 = params[7]:gsub("\n",""):gsub(':','')
drb4 = params[8]:gsub("\n",""):gsub(':','')
drb = params[9]:gsub("\n",""):gsub(':','')
-- aktualisan megadott mennyiseg
if (drb2=='') then drb2='0' end
if (tonumber(drb2)>0) then
    -- vart mennyiseg
    if (drb=='') then drb='0' end
    -- kezelo altal atveve
    if (drb3=='') then drb3='0' end
    -- osszesen atveve (ha tobb kezelo van)
    if (drb4=='') then drb4='0' end
    ujdrb = tonumber(drb2) + tonumber(drb3)
    if (tonumber(drb4) + tonumber(drb2)<=tonumber(drb)) then
        kezelo = ui:getKezelo()
        kulsoraktar = ui:getGlobal("kulsoraktar")
        str = 'beerk_ment ' .. fejazon .. ' ' .. cegazon .. ' ' .. cikk .. ' ' .. ean .. ' ' .. ujdrb .. ' ' .. kezelo .. ' ' .. kulsoraktar
        t=luafunc.query_assoc(str,false)
        ui:executeCommand('valueto','lmibiz', t[1]['MIBIZ'])
        ui:executeCommand('valuetohidden','lfejazon', t[1]['AZON'])
        result = t[1]['RESULT']
        resulttext = t[1]['RESULTTEXT']
        if (result=='0') then
            ui:executeCommand('TOAST','Mentés rendben.')
        else
            --ui:executeCommand('TOAST','Hiba:' .. resulttext)
            alert(ui,resulttext)
            ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
        end
        ui:executeCommand('hideobj','cap_drb;cap_drb4;cap_drb3;cap_drb2;button_ujean;lcikknev','')
        ui:executeCommand('valueto','eean', '')
        ui:executeCommand('valuetohidden','edrb2', '')
        ui:executeCommand('valuetohidden','ldrb3', '')
        ui:executeCommand('valuetohidden','ldrb4', '')
        ui:executeCommand('valuetohidden','ldrb', '')
        ui:executeCommand('setfocus','eean', '')
    else
        alert(ui,'Túl sok átvétel!\n'..'Várt mennyiség:'..drb..' Eddig összesen átvett:' .. drb4)
        ui:executeCommand('valueto','edrb2','')
        ui:executeCommand('setfocus','edrb2', '')
    end
else
        alert(ui,'Mennyiség nem lehet nulla!')
        ui:executeCommand('valueto','edrb2','')
        ui:executeCommand('setfocus','edrb2', '')
end
