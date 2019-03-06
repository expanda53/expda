--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
hkod = params[2]:gsub("n",""):gsub(':',''):gsub("%%20"," ")
--hkod ellenorzes
if (hkod:len()<=10) then
    --hkod ellenorzes
    ahkod=hkod
    hkod = hkod:gsub(" ","%%20")
    str = 'hkod_check '..hkod
    t=luafunc.query_assoc(str,false)
    result=t[1]['RESULT']
else
    result='-11'
end
if (result=='0') then
    ui:executeCommand("startlua","kiadej/ujcikk.lua", '')
else
 if (result=='-11') then
    msg = 'A helykód hossza max 10 karakter lehet!'    
 else
    msg = 'Nem található a rendszerben ilyen helykód:\n'
 end
 alert(ui,msg..ahkod)

 ui:executeCommand('valueto','ehkod','')
 ui:executeCommand('setfocus','ehkod','')   
end


