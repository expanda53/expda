--<verzio>20170201</verzio>
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
    hkod= t['HKOD']:gsub("Helykód","")
    aktdrb = t['DRB2']
    if (aktdrb==nil or aktdrb=='') then
      aktdrb='0'
    else
      aktdrb = aktdrb:gsub("Kiszedve: ","")
    end
    
    if (tonumber(aktdrb)>0) then
      ui:showDialog("Biztos újrakezdi a kiszedést erre a sorra?","kiadas/javit.lua "..fejazon.." igen " .. cikk .. ' '..hkod,"kiadas/javit.lua 0 nem")
    end
elseif (dialogres=="igen") then
        kezelo = ui:getKezelo()
        kulsoraktar = ui:getGlobal("kulsoraktar")
        cikk = params[4]:gsub("\n",""):gsub(':','')
        hkod = params[5]:gsub("\n",""):gsub(':','')
        ui:executeCommand('startlua','kiadas/mentes.lua',fejazon..' '..cikk..' . '..hkod..' 0 0 0 .')
        str = 'kiadas_cikklist ' .. kezelo .. ' ' .. fejazon
        list=luafunc.query_assoc_to_str(str,false)
        luafunc.refreshtable_fromstring('atnezo_table',list)
        ui:executeCommand("hideobj","reviewpaneldlg")
        ui:executeCommand("showobj","reviewpanel")
end
