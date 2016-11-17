--<verzio>20161101</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
kezelo = ui:getKezelo()
--ui:executeCommand('uzenet',dialogres)
mibiz = tostring(ui:findObject('lmibiz'):getText())
sorsz = tostring(ui:findObject('lsorsz'):getText())
cikknev = tostring(ui:findObject('lcikknev'):getText())
if (dialogres=="null") then
    row = ui:findObject('gyszam_table'):getSelectedRow()  
    t = luafunc.rowtotable(row)
    gyszam= t['GYSZAM']
    ui:showDialog("Törli a " .. gyszam .. " gyáriszámot erről a cikkről?\n"..cikknev.."\n".. mibiz.."/" .. sorsz,"bevet/gyszamlist_click.lua igen ".. gyszam,"bevet/gyszamlist_click.lua nem")
end
if (dialogres=="igen") then
        gyszam = params[3]    
        str = 'kiadas_gyszam_torol '..mibiz..' '..sorsz..' '..gyszam..' '..kezelo
        --ui:executeCommand('uzenet',str)
        t=luafunc.query_assoc(str,false)
        if (t[1]['RESULTTEXT']=='OK') then
            str = 'kiadas_gyszamlist '..mibiz..' '..sorsz..' '..kezelo
            list=luafunc.query_assoc_to_str(str,false)
            luafunc.refreshtable_fromstring('gyszam_table',list)
        end
end

