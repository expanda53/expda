--<verzio>20170329</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui = params[1]
dialogres = params[2]    
kezelo = ui:getKezelo()
mibiz = tostring(ui:findObject('lmibiz'):getText())
if (dialogres=="null") then
    ui:showDialog("Biztos zárható a kiszedés ellenőrzés? ".. mibiz,"ellenor/lezaras.lua igen ","ellenor/lezaras.lua nem")
end
if (dialogres=="igen") then
            fejazon = tostring(ui:findObject('lfejazon'):getText())
            str = 'ellenor_lezaras ' .. fejazon .. ' ' .. kezelo
            list=luafunc.query_assoc(str,false)
            str = list[1]['RESULTTEXT']
            
            if (str=='OK') then
                ui:executeCommand('TOAST','Lezárás rendben.')
                ui:executeCommand('CLOSE','','')
            elseif (str=='OKELTERES') then
                ui:executeCommand('TOAST','Lezárás rendben, eltérés bizonylat készült! ' .. mibiz..'E')
                ui:executeCommand('CLOSE','','')
            else
                alert(ui,str)
                --ui:executeCommand('uzenet',str)
            end
end

