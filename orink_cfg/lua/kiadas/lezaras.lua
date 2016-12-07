--<verzio>20161206</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
--ui:executeCommand('uzenet',dialogres)
if (dialogres=="null") then
    mibiz = tostring(ui:findObject('lmibiz'):getText())
    ui:showDialog("Biztos zárható a kiadás? ".. mibiz,"kiadas/lezaras.lua igen ","kiadas/lezaras.lua nem")
end
if (dialogres=="igen") then
        kezelo = ui:getKezelo()
        fejazon = tostring(ui:findObject('lfejazon'):getText())
        str = 'kiadas_lezaras '..fejazon..' '.. kezelo
        list=luafunc.query_assoc(str,false)
        str = list[1]['RESULTTEXT']
            
        if (str=='OK') then
                ui:executeCommand('TOAST','Lezárás rendben.')
                ui:executeCommand('CLOSE','','')
        else
                ui:executeCommand('uzenet',str)
        end
end

