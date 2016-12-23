--<verzio>20161223</verzio>
require '.egyeb.functions'
local params = {...}
ui = params[1]
fejazon = params[2]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'leltar_kesobbfolyt ' .. fejazon .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
result = t[1]['RESULT']
resulttext = t[1]['RESULTTEXT']
if (result=='0') then
    ui:executeCommand('TOAST','Leltár megszakítás rendben.')
else
    alert(ui,'Hiba:' .. resulttext)
end
ui:executeCommand("close","","")