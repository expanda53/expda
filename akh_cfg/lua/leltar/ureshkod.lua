--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
kezelo = ui:getKezelo()
uzmod=ui:getGlobal("uzmod")
azon = tostring(ui:findObject('lfejazon'):getText())
hkod = tostring(ui:findObject('ehkod'):getText())
--ures helykodra ZZNYITO cikk mentese 0 drb es drb2-vel
 str = 'leltar_ment ' .. azon .. ' ' .. hkod .. ' ZZNYITO ZZNYITO 0 X ' ..kezelo ..' '.. uzmod
 t=luafunc.query_assoc(str,false)
 result = t[1]['RESULT']

if (result=='0') then
    ui:executeCommand('toast','Üres helykód mentés rendben.', "")
    ui:executeCommand('startlua','leltar/showreview.lua', "")
else
 ui:executeCommand('setfocus','ehkod','') 
 if (result=='-2') then 
    msg = 'Ezt a helykódot nem lehet üresre állítani, már van rá leltár:\n'
 else
    msg = 'Adatbázis hiba történt:\n'
 end
 alert(ui,msg..hkod)
 ui:executeCommand('valueto','ehkod','')

end
