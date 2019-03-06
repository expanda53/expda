--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
if (dialogres=="null") then
    row = ui:findObject('mibizlist_table'):getSelectedRow()  
    --txt = row:toString()
    --ui:executeCommand('uzenet',txt)
    t = luafunc.rowtotable(row)
    cegnev= t['NEV']
    mibiz= t['MIBIZ']
    azon= t['AZON']
    ui:executeCommand('valuetohidden','lcegnev', cegnev)
    ui:executeCommand('valuetohidden','lmibiz', mibiz)
    ui:showDialog("Kiválasztott bizonylat: " .. mibiz .. "\ncég: " .. cegnev .. "\nIndítható a kiadás?","kiadkesz/mibizlist_click.lua igen " .. azon,"kiadkesz/mibizlist_click.lua nem")
end
if (dialogres=="igen") then
    kezelo = ui:getKezelo()
    azon = params[3]    
    str = 'kiadkesz_init '..azon..' '..kezelo
    q=luafunc.query_assoc(str,false)
    if (q[1]['RESULT']~='0') then
        text = q[1]['RESULTTEXT']
        ui:executeCommand('uzenet',text, '')
    else
        ui:executeCommand('valuetohidden','lfejazon', azon)
        ui:executeCommand('show','lmibiz;lcegnev','')
        ui:executeCommand('hideobj','mibizlistpanel','')
        ui:executeCommand('showobj','pfooter;button_review','')
        ui:executeCommand('startlua','kiadkesz/kovetkezo_click.lua', azon..' . . 1')
        ui:executeCommand('aktbcodeobj','bcode1','')
    end
end

