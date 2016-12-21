--<verzio>20161215</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
kezelo = ui:getKezelo()
mibiz = tostring(ui:findObject('lmibiz'):getText())
if (dialogres=="null") then
    ui:showDialog("Biztos zárható a beérkezés? ".. mibiz,"bevet/lezaras.lua igen ","bevet/lezaras.lua nem")
end
if (dialogres=="igen") then
            fejazon = tostring(ui:findObject('lfejazon'):getText())
            rentip = tostring(ui:findObject('lrentip'):getText())
            str = 'beerk_lezaras ' .. kezelo .. ' ' .. fejazon .. ' ' ..rentip
            list=luafunc.query_assoc(str,false)
            str = list[1]['RESULTTEXT']
            
            if (str=='OK') then
                ui:executeCommand('TOAST','Lezárás rendben.')
                ui:executeCommand('CLOSE','','')
            else
                ui:executeCommand('playaudio','alert.mp3','')
                ui:executeCommand('uzenet',str)
            end
end

