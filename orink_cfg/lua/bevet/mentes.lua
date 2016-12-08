--<verzio>20161206</verzio>
require 'hu.expanda.expda/LuaFunc'
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
-- vart mennyiseg
if (drb=='') then drb='0' end
-- kezelo altal atveve
if (drb3=='') then drb3='0' end
-- osszesen atveve (ha tobb kezelo van)
if (drb4=='') then drb4='0' end
ujdrb = tonumber(drb2) + tonumber(drb3)
if (tonumber(drb4) + tonumber(drb2)<=tonumber(drb)) then
    kezelo = ui:getKezelo()
    str = 'beerk_ment ' .. fejazon .. ' ' .. cegazon .. ' ' .. cikk .. ' ' .. ean .. ' ' .. ujdrb .. ' ' .. kezelo
    t=luafunc.query_assoc(str,false)
    ui:executeCommand('valueto','lmibiz', t[1]['MIBIZ'])
    ui:executeCommand('valuetohidden','lfejazon', t[1]['AZON'])
    result = t[1]['RESULT']
    resulttext = t[1]['RESULTTEXT']
    if (result=='0') then
        ui:executeCommand('TOAST','Mentés rendben.')
    else
        --ui:executeCommand('TOAST','Hiba:' .. resulttext)
        ui:executeCommand('playaudio','alert.mp3','')
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
    ui:executeCommand('playaudio','alert.mp3','')
    ui:executeCommand('toast','Túl sok átvétel!\n'..'Várt mennyiség:'..drb..' Eddig összesen átvett:' .. drb4, '')
    ui:executeCommand('valueto','edrb2','')
    ui:executeCommand('setfocus','edrb2', '')
end

