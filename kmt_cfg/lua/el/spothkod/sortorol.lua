--<verzio>20170212</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
fejazon = params[2]:gsub("\n",""):gsub(':','')
dialogres = params[3]
if (dialogres=="null") then
    row = ui:findObject('atnezo_table'):getSelectedRow()  
    t = luafunc.rowtotable(row)
    cikk= t['CIKK']
    aktdrb = t['DRB']

    if (aktdrb==nil or aktdrb=='') then
      aktdrb='0'
    else
      aktdrb = aktdrb:gsub("Számolt: ","")
    end
    if (tonumber(aktdrb)>0) then
      ui:showDialog("Biztos törli a spotleltár sorát?","spothkod/sortorol.lua "..fejazon.." igen " .. cikk,"spothkod/sortorol.lua 0 nem")
    end
elseif (dialogres=="igen") then
        kezelo = ui:getKezelo()
        kulsoraktar = ui:getGlobal("kulsoraktar")
        cikk = params[4]:gsub("\n",""):gsub(':','')
        str = 'spothkod_ment ' .. fejazon .. ' ' .. '.' .. ' ' .. cikk .. ' ' .. '.' .. ' ' .. 0 .. ' ' .. kezelo .. ' ' .. kulsoraktar
        
        t=luafunc.query_assoc(str,false)
        result = t[1]['RESULT']
        resulttext = t[1]['RESULTTEXT']
        if (result=='0') then
            ui:executeCommand('TOAST','Törlés rendben.')
        else
            alert(ui,resulttext)
            ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
        end
        str = 'spothkod_cikklist ' .. kezelo .. ' ' .. fejazon
        list=luafunc.query_assoc_to_str(str,false)
        luafunc.refreshtable_fromstring('atnezo_table',list)
        ui:executeCommand("showobj","reviewpanel")
end
