--<verzio>20170118</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
fejazon = params[2]:gsub("\n",""):gsub(':','')
cegazon = params[3]:gsub("\n",""):gsub(':','')
dialogres = params[4]
if (dialogres=="null") then
    row = ui:findObject('atnezo_table'):getSelectedRow()  
    t = luafunc.rowtotable(row)
    cikk= t['CIKK']
    ean= t['EAN']
    aktdrb = t['DRB']

    if (aktdrb==nil or aktdrb=='') then
      aktdrb='0'
    else
      aktdrb = aktdrb:gsub("Érkezett: ","")
    end
    if (tonumber(aktdrb)>0) then
      if (ean==nil or ean=='') then
        ean=":"
      end
      ui:showDialog("Biztos törli a beérkezés sorát?","bevet/sortorol.lua "..fejazon.." "..cegazon.." igen " .. cikk .. ' '..ean,"bevet/sortorol.lua 0 0 nem")
    end
elseif (dialogres=="igen") then
        kezelo = ui:getKezelo()
        kulsoraktar = ui:getGlobal("kulsoraktar")
        cikk = params[5]:gsub("\n",""):gsub(':','')
        ean = params[6]:gsub("\n",""):gsub(':','')

        str = 'beerk_ment ' .. fejazon .. ' ' .. cegazon .. ' ' .. cikk .. ' ' .. ean .. ' ' .. 0 .. ' ' .. kezelo .. ' ' .. kulsoraktar
        t=luafunc.query_assoc(str,false)
        result = t[1]['RESULT']
        resulttext = t[1]['RESULTTEXT']
        if (result=='0') then
            ui:executeCommand('TOAST','Törlés rendben.')
        else
            alert(ui,resulttext)
            ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
        end
        str = 'beerk_cikklist ' .. kezelo .. ' ' .. fejazon
        list=luafunc.query_assoc_to_str(str,false)
        luafunc.refreshtable_fromstring('atnezo_table',list)
        ui:executeCommand("showobj","reviewpanel")
end
