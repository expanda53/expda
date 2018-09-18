--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
fejazon = params[2]:gsub("\n",""):gsub(':','')
cikklot = params[3]:gsub("\n",""):gsub(':','')
drb = params[4]:gsub("\n",""):gsub(':','')
maxdrb = params[5]:gsub("\n",""):gsub(':','')
hkod = params[6]:gsub("\n",""):gsub(':','')
if (drb=='') then drb='0' end
if (maxdrb=='') then maxdrb='0' end
if (tonumber(drb)>0) then
   if (tonumber(drb)<=tonumber(maxdrb)) then
        kezelo = ui:getKezelo()
        str = 'beerk_ment ' .. fejazon .. ' ' .. cikklot .. ' ' .. drb .. ' ' .. hkod .. ' ' .. kezelo 
        t=luafunc.query_assoc(str,false)
        result = t[1]['RESULT']
        resulttext = t[1]['RESULTTEXT']
        if (result=='0') then
            ui:executeCommand('TOAST','Mentés rendben.')
        else
            --ui:executeCommand('TOAST','Hiba:' .. resulttext)
            alert(ui,resulttext)
            ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua elot")
        end
        
        ui:executeCommand('hideobj','cap_drb;cap_maxdrb;button_ujlot;lcikknev','')
        ui:executeCommand('valueto','elot', '')
        ui:executeCommand('valuetohidden','edrb', '')
        ui:executeCommand('valuetohidden','lmaxdrb', '0')
        if (result=='0' or result~='0') then
          ui:executeCommand('setfocus','elot', '')
        end
    else
        alert(ui,'Túl sok átvétel!\n Max átvehető:' .. maxdrb)
        ui:executeCommand('valueto','edrb','')
        ui:executeCommand('setfocus','edrb', '')
    end
else
        alert(ui,'Mennyiség nem lehet nulla!')
        ui:executeCommand('valueto','edrb','')
        ui:executeCommand('setfocus','edrb', '')
end
