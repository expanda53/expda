--<verzio>20161101</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
kezelo = ui:getKezelo()
--ui:executeCommand('uzenet',dialogres)
mibiz = tostring(ui:findObject('lmibiz'):getText())
if (dialogres=="null") then
    row = ui:findObject('atnezo_table'):getSelectedRow()  
    t = luafunc.rowtotable(row)
    cikk= t['CIKK']
    cikknev = t['CIKKNEV']
    ui:showDialog("Törli a gyáriszámokat erről a cikkről?\n"..cikknev.."\n".. mibiz,"leltar/atnezes_click.lua igen ".. cikk,"leltar/atnezes_click.lua nem")
end
if (dialogres=="igen") then
        cikk = params[3]    
        str = 'gyszamleltar_gyszam_torol '..mibiz..' '..cikk..' . '..kezelo
        --ui:executeCommand('uzenet',str)
        t=luafunc.query_assoc(str,false)
        if (t[1]['RESULTTEXT']=='OK') then
            str = 'gyszamleltar_cikklist '..kezelo..' '..mibiz
            list=luafunc.query_assoc_to_str(str,false)
            if (list~=nil) then
              luafunc.refreshtable_fromstring('atnezo_table',list)
              ui:executeCommand('show','atnezo_table','')
            else
              ui:executeCommand('hide','atnezo_table','')
            end
            
            --str = 'kiadas_review_sum '..kezelo..' '..mibiz
            --sum=luafunc.query_assoc(str,false)
            --drb2 = sum[1]['DRB2']
            --ui:executeCommand("valueto","lkiszedve",'Bevéve ' ..drb2 .. ' drb')
            
        end
end

