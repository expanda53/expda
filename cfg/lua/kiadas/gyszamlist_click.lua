require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
kezelo='100'
--ui:executeCommand('uzenet',dialogres)
mibiz = tostring(ui:findObject('lmibiz'):getText())
sorsz = tostring(ui:findObject('lsorsz'):getText())
cikknev = tostring(ui:findObject('lcikknev'):getText())
if (dialogres=="null") then
    row = ui:findObject('gyszam_table'):getSelectedRow()  
    t = luafunc.rowtotable(row)
    gyszam= t['GYSZAM']
    ui:showDialog("Törli a gyáriszámot erről a cikkről?\n"..cikknev.."\n".. mibiz.."/" .. sorsz,"kiadas/gyszamlist_click.lua igen ".. sorsz,"kiadas/gyszamlist_click.lua nem")
end
if (dialogres=="igen") then
        sorsz = params[3]    
        str = 'kiadas_gyszam_torol '..mibiz..' '..sorsz..' '..kezelo
        --ui:executeCommand('uzenet',str)
        t=luafunc.query_assoc(str,false)
        if (t[1]['RESULTTEXT']=='OK') then
            str = 'kiadas_cikklist 100 '..mibiz
            list=luafunc.query_assoc_to_str(str,false)
            luafunc.refreshtable_fromstring('gyszam_table',list)
        end
end

