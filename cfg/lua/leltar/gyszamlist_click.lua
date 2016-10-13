require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
kezelo = ui:getKezelo()
--ui:executeCommand('uzenet',dialogres)
mibiz = tostring(ui:findObject('lmibiz'):getText())
cikk = tostring(ui:findObject('lcikod'):getText())
cikknev = tostring(ui:findObject('lcikknev'):getText())
if (dialogres=="null") then
    row = ui:findObject('gyszam_table'):getSelectedRow()  
    t = luafunc.rowtotable(row)
    gyszam= t['GYSZAM']
    ui:showDialog("Törli a " .. gyszam .. " gyáriszámot erről a cikkről?\n"..cikknev.."\n".. mibiz,"leltar/gyszamlist_click.lua igen ".. gyszam,"leltar/gyszamlist_click.lua nem")
end
if (dialogres=="igen") then
        gyszam = params[3]    
        str = 'gyszamleltar_gyszam_torol '..mibiz..' '..cikk..' '..gyszam..' '..kezelo
        --ui:executeCommand('uzenet',str)
        t=luafunc.query_assoc(str,false)
        if (t[1]['RESULTTEXT']=='OK') then
            drb2= t[1]['DRB2']
            ui:executeCommand('valueto','ldrb2',drb2)
            str = 'gyszamleltar_gyszamlist '..mibiz..' '..cikk..' '..kezelo
            list=luafunc.query_assoc_to_str(str,false)
            if (list~=nil) then
              luafunc.refreshtable_fromstring('gyszam_table',list)
              ui:executeCommand('showobj','gyszam_table','')
            else 
              ui:executeCommand('hideobj','gyszam_table','')
            end
        end
end

