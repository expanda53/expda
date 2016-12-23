--<verzio>20161223</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
cikk = params[2]:gsub("n",""):gsub(':','')
ean = params[3]:gsub("n",""):gsub(':','')
drb = params[4]:gsub("n",""):gsub(':','')
fejazon = params[5]:gsub("n",""):gsub(':','')
hkod = params[6]:gsub("n",""):gsub(':','')
if (tonumber(drb)>0) then
    kezelo = ui:getKezelo()
    kulsoraktar = ui:getGlobal("kulsoraktar")
    str = 'leltar_ment ' .. fejazon .. ' ' .. hkod .. ' ' .. cikk .. ' ' .. ean .. ' ' .. drb .. ' ' .. kezelo .. ' ' .. kulsoraktar
    t=luafunc.query_assoc(str,false)
    ui:executeCommand('valueto','lmibiz', t[1]['MIBIZ'])
    ui:executeCommand('valuetohidden','lfejazon', t[1]['AZON'])
    result = t[1]['RESULT']
    resulttext = t[1]['RESULTTEXT']
    if (result=='0') then
        ui:executeCommand('TOAST','Mentés rendben.')
    else
        --ui:executeCommand('TOAST','Hiba:' .. resulttext)
        alert(ui,"")
        ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
    end
    ui:executeCommand('hideobj','cap_drb;edrb;button_ujean;lcikknev','')
    ui:executeCommand('setfocus','eean', '')
    ui:executeCommand('valueto','eean', '')
else
    alert(ui,'Mennyiség nem lehet nulla!')
    ui:executeCommand('valueto','edrb','')
    ui:executeCommand('setfocus','edrb', '')

end

