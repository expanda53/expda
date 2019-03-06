--<verzio>20180216</verzio>
require '.egyeb.functions'
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
hkod = params[2]:gsub("n",""):gsub(':','')
hossz=hkod:len()
if (hossz>0 and hossz<=10) then
    kulsoraktar = ui:getGlobal("kulsoraktar")
    --hkod ellenorzes
    str = 'hkod_check '..hkod..' '..kulsoraktar
    t=luafunc.query_assoc(str,false)
    result=t[1]['RESULT']
else
    result='-11'
end
if (result=='0') then
    ui:executeCommand('disabled','ehkod','')
    ui:executeCommand('setbgcolor','ehkod','#434343')
    ui:executeCommand('showobj','cap_drb;edrb','')      
    ui:executeCommand('setfocus','edrb','')   
else
 if (result=='-2') then 
    msg = 'Téves raktár választás, ebben a raktárban nem található ilyen helykód:\n'
 elseif (result=='-11') then
    msg = 'A helykód hossza min 1, max 10 karakter lehet!'    
 else
    msg = 'Nem található a rendszerben ilyen helykód:\n'
 end
 alert(ui,msg..hkod)

 ui:executeCommand('valueto','ehkod','')
 ui:executeCommand('setfocus','ehkod','')   
end




