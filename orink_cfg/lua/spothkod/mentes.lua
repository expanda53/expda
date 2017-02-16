--<verzio>20170212</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
cikk = params[2]:gsub("\n",""):gsub(':','')
ean = params[3]:gsub("\n",""):gsub(':','')
drb = params[4]:gsub("\n",""):gsub(':',''):gsub('-','')
fejazon = params[5]:gsub("\n",""):gsub(':','')
hkod = params[6]:gsub("\n",""):gsub(':','')
if (tonumber(drb)>0) then
    kezelo = ui:getKezelo()
    kulsoraktar = ui:getGlobal("kulsoraktar")
    mehet=1
    if (mehet==1) then
        str = 'spothkod_ment ' .. fejazon .. ' ' .. hkod .. ' ' .. cikk .. ' ' .. ean .. ' ' .. drb .. ' ' .. kezelo .. ' ' .. kulsoraktar
        t=luafunc.query_assoc(str,false)
        result = t[1]['RESULT']
        resulttext = t[1]['RESULTTEXT']
        if (result=='0') then
            ui:executeCommand('TOAST','Mentés rendben.')
        else
            --ui:executeCommand('TOAST','Hiba:' .. resulttext)
            if (resulttext=='') then
              resulttext='Hiba a mentés során ('.. result ..')!'
            end
            alert(ui,resulttext)
            --ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
        end
        ui:executeCommand('valuetohidden','edrb', '')
        ui:executeCommand('hideobj','cap_drb;lcikknev','')
        ui:executeCommand('valueto','eean', '')
        ui:executeCommand('setfocus','eean', '')
    end
else
  alert(ui,'Mennyiség nem lehet nulla!')
  ui:executeCommand('valueto','edrb', '')
  ui:executeCommand('setfocus','edrb', '')
end

