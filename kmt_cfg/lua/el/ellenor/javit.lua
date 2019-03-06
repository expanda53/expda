--<verzio>20170404</verzio>
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
    aktdrb = t['DRB2']
    if (aktdrb==nil or aktdrb=='') then
      aktdrb='0'
    else
      aktdrb = aktdrb:gsub("Ellenorizve: ","")
    end
    
    if (tonumber(aktdrb)>0) then
      ui:showDialog("Biztos újrakezdi az ellenőrzést erre a sorra?","ellenor/javit.lua "..fejazon.." igen " .. cikk,"ellenor/javit.lua 0 nem")
    end
elseif (dialogres=="igen") then
        kezelo = ui:getKezelo()
        cikk = params[4]:gsub("\n",""):gsub(':','')
        ui:executeCommand('startlua','ellenor/mentes.lua',fejazon..' '..cikk..' . 0 0 0')
        str = 'ellenor_cikklist ' .. kezelo .. ' ' .. fejazon
        list=luafunc.query_assoc_to_str(str,false)
        luafunc.refreshtable_fromstring('atnezo_table',list)
end
