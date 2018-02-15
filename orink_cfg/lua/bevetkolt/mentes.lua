--<verzio>20180213</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
cikk = params[2]:gsub("\n",""):gsub(':','')
ean = params[3]:gsub("\n",""):gsub(':','')
drb = params[4]:gsub("\n",""):gsub(':',''):gsub('-','')
if (drb=='' or drb==nil) then
  drb = 0
end  
fejazon = params[5]:gsub("\n",""):gsub(':','')
hkod = params[6]:gsub("\n",""):gsub(':','')
hkod_regi = params[7]:gsub("\n",""):gsub(':','')
if (tonumber(drb)>0) then
    kezelo = ui:getKezelo()
    kulsoraktar = "BEER"
    mehet=1
    maxdrb = tostring(ui:findObject('lmaxdrb'):getText())
    if (maxdrb=='') then maxdrb="0" end
    if (tonumber(maxdrb)<tonumber(drb)) then mehet=0 end
    if (mehet==1) then
        str = 'bevetkolt_ment ' .. fejazon .. ' ' .. hkod .. ' ' .. cikk .. ' ' .. ean .. ' ' .. drb .. ' ' .. kezelo .. ' ' .. kulsoraktar .. ' ' .. hkod_regi
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
        ui:executeCommand('valuetohidden','edrb', '')
        ui:executeCommand('startlua','bevetkolt/ujean.lua','')
    else
        ui:executeCommand('TOAST','Max betárolható: '..maxdrb)
    end
else
  alert(ui,'Mennyiség nem lehet nulla!')
  ui:executeCommand('valueto','edrb', '')
  ui:executeCommand('setfocus','edrb', '')
end

