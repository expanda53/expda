--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
cikk = params[2]:gsub("n",""):gsub(':','')
drb = params[3]:gsub("n",""):gsub(':','')
fejazon = params[4]:gsub("n",""):gsub(':','')
drb2 = params[5]:gsub("n",""):gsub(':','')
dialogres = params[6]:gsub("\n",""):gsub(':','')
if (dialogres=='') then
  dialogres='null'
end  
if (drb2=='') then
  drb2='0'
end
if (drb==nil or drb=='') then
  drb=0
end  

--ez mar nem kell, mert a cikk loves utan mondja meg hogy mi legyen (bcode1.lua, leltaradd.lua)
if (dialogres=="null") then
    if (tonumber(drb2)~=0) then
      ui:showDialog("Van már ilyen tétel a jelentésben.\n\nNem: Hozzáadja\nIgen: Felülírja","keszrejel/mentes.lua "..cikk.." " .. drb .. " " ..fejazon .. " " .. drb2 .. " felulir","keszrejel/mentes.lua "..cikk.." " .. drb .. " " ..fejazon .. " " .. drb2 .. " hozzaad")
    else
      dialogres = "felulir"
    end
end

if (dialogres~="null") then
    if (dialogres=="hozzaad") then
        --hozzaadas
        drb = tonumber(drb2) + tonumber(drb)
    end
    if (tonumber(drb)>0) then
        kezelo = ui:getKezelo()
        str = 'keszrejel_ment ' .. fejazon .. ' ' .. cikk .. ' ' .. drb .. ' ' .. kezelo 
        t=luafunc.query_assoc(str,false)
        if (fejazon=='0') then
          ui:executeCommand('valueto','lmibiz', t[1]['MIBIZ'])
          ui:executeCommand('valuetohidden','lfejazon', t[1]['AZON'])
        end
        result = t[1]['RESULT']
        resulttext = t[1]['RESULTTEXT']
        if (result=='0') then
            ui:executeCommand('TOAST','Mentés rendben.')
        else
            --ui:executeCommand('TOAST','Hiba:' .. resulttext)
            alert(ui,"")
            ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua ecikod")
        end
        ui:executeCommand('hideobj','cap_drb;edrb;button_ujcikk;lcikknev;cap_drb2;ldrb2','')
        ui:executeCommand('setfocus','ecikod', '')
        ui:executeCommand('valueto','ecikod', '')
    else
        alert(ui,'Mennyiség nem lehet nulla!')
        ui:executeCommand('valueto','edrb','')
        ui:executeCommand('setfocus','edrb', '')

    end
end    

