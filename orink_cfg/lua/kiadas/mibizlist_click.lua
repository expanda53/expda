--<verzio>20170127</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
if (dialogres=="null") then
    row = ui:findObject('mibizlist_table'):getSelectedRow()  
    --txt = row:toString()
    --ui:executeCommand('uzenet',txt)
    t = luafunc.rowtotable(row)
    cegnev= t['CEGNEV']
    mibiz= t['MIBIZ']
    azon= t['AZON']
    ui:executeCommand('valuetohidden','lcegnev', cegnev)
    ui:executeCommand('valuetohidden','lmibiz', mibiz)
    ui:showDialog("Kiválasztott bizonylat: " .. mibiz .. "\ncég: " .. cegnev .. "\nIndítható a kiadás?","kiadas/mibizlist_click.lua igen " .. azon,"kiadas/mibizlist_click.lua nem")
end
if (dialogres=="igen") then
    kezelo = ui:getKezelo()
    azon = params[3]    
    kulsoraktar = ui:getGlobal("kulsoraktar")
    str = 'kiadas_init '..azon..' '..kezelo.. ' ' .. kulsoraktar
    q=luafunc.query_assoc(str,false)
    if (q[1]['RESULT']~='0') then
        text = q[1]['RESULTTEXT']
        ui:executeCommand('uzenet',text, '')
    else
        ui:executeCommand('valuetohidden','lfejazon', azon)
        ui:executeCommand('show','lmibiz;lcegnev','')
        ui:executeCommand('hideobj','mibizlistpanel','')
        ui:executeCommand('showobj','pfooter;button_review','')
        ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', azon..' . . 1')
        ui:executeCommand('aktbcodeobj','bcode1','')
    end
end

