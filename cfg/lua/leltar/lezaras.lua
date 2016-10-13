require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
dialogres = params[2]    
kezelo = ui:getKezelo()
--ui:executeCommand('uzenet',dialogres)
mibiz = tostring(ui:findObject('lmibiz'):getText())
if (dialogres=="null") then
    ui:showDialog("Biztos zárható a bevét? ".. mibiz,"bevet/lezaras.lua igen ","bevet/lezaras.lua nem")
end
if (dialogres=="igen") then
        str = 'kiadas_lezaras_check '..mibiz..' '..kezelo
        --ui:executeCommand('uzenet',str)
        t=luafunc.query_assoc(str,false)

        hibastr = "Összesen bevéve: " .. t[1]['KIADVA'] .. " db\n"

        stop = 0
        if (t[1]['TOBBLET']~='0') then
            stop=1
        end
        hibastr = hibastr .. "Többlet bevét: " .. t[1]['TOBBLET'] .. " db\n"
        if (t[1]['HIANY']~='0') then
            stop=1
        end
        hibastr = hibastr .. "Hiány: " .. t[1]['HIANY'] .. " db\n"
        
        if (stop~=0) then
            hibastr = hibastr .. "\nLezárás leállítva."
            ui:showMessage(hibastr)
        else
            --ui:showMessage(hibastr)
            str = 'bevet_lezaras '..mibiz..' '.. kezelo
            list=luafunc.query_assoc(str,false)
            str = list[1]['RESULTTEXT']
            
            if (str=='OK') then
                ui:executeCommand('TOAST','Lezárás rendben.')
                ui:executeCommand('CLOSE','','')
            else
                ui:executeCommand('uzenet',str)
            end
        end
        
        
end

