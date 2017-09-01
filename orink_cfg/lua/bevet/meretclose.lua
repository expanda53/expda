--<verzio>20170831</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
cikk = tostring(ui:findObject('lcikod'):getText())
meret = params[2]:gsub("\n",""):gsub(':','')
suly = params[3]:gsub("\n",""):gsub(':','')
ui:executeCommand('valueto','lmeret', meret)
ui:executeCommand('valueto','lsuly', suly)

if (meret=='') then meret='.' end
if (suly=='') then suly='.' end
if (cikk=='') then cikk='.' end
kezelo = ui:getKezelo()
str = 'meretment ' .. cikk .. ' ' .. meret .. ' ' .. suly .. ' ' .. kezelo 
t=luafunc.query_assoc(str,false)
result = t[1]['RESULT']
resulttext = t[1]['RESULTTEXT']
if (result=='0') then
    ui:executeCommand('TOAST','Méret, súly mentés rendben.')
else 
    alert(ui,resulttext)
end
ui:executeCommand('hideobj','meretpanel','')
ui:executeCommand('setfocus','eean', '')