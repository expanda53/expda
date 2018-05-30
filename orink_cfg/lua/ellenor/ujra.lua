--<verzio>20180523</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui = params[1]
dialogres = params[2]    
kezelo = ui:getKezelo()
mibiz = tostring(ui:findObject('lmibiz'):getText())
if (dialogres=="null") then
    ui:showDialog("Biztos újrakezdi a kiszedés ellenőrzést? ".. mibiz,"ellenor/ujra.lua igen ","ellenor/ujra.lua nem")
end
if (dialogres=="igen") then
            fejazon = tostring(ui:findObject('lfejazon'):getText())
            szures = tostring(ui:findObject('combo_szures'):getText())
            str = 'ellenor_ujra ' .. fejazon .. ' ' .. kezelo
            list=luafunc.query_assoc(str,false)
            str = list[1]['RESULTTEXT']
            
            if (str=='OK') then
                ui:executeCommand('TOAST','Ellenőrzés újrakezdhető.')
                ui:executeCommand("startlua","ellenor/atnezo_szures.lua", szures .. ' ' .. fejazon)

                --ui:executeCommand('CLOSE','','')
            else
                alert(ui,str)
                --ui:executeCommand('uzenet',str)
            end
end

