require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
kezelo='100'
--ui:executeCommand('uzenet',dialogres)
mibiz = tostring(ui:findObject('lmibiz'):getText())
if (dialogres=="null") then
    row = ui:findObject('atnezo_table'):getSelectedRow()  
    t = luafunc.rowtotable(row)
    sorsz= t['SORSZ']
    cikknev = t['CIKKNEV']
    drb2=t['DRB2']
    if (drb2~='0') then
      ui:showDialog("Törli a gyáriszámokat erről a cikkről?\n"..cikknev.."\n".. mibiz.."/" .. sorsz,"kiadas/atnezes_click.lua igen ".. sorsz,"kiadas/atnezes_click.lua nem")
    end
end
if (dialogres=="igen") then
        sorsz = params[3]    
        str = 'kiadas_gyszam_torol '..mibiz..' '..sorsz..' '..kezelo
        --ui:executeCommand('uzenet',str)
        t=luafunc.query_assoc(str,false)
        if (t[1]['RESULTTEXT']=='OK') then
            str = 'kiadas_cikklist 100 '..mibiz
            list=luafunc.query_assoc_to_str(str,false)
            luafunc.refreshtable_fromstring('atnezo_table',list)
        end
end

