--<verzio>20161121</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
fejazon = params[2]:gsub("n",""):gsub(':','')
cegazon = params[3]:gsub("n",""):gsub(':','')
cikk = params[4]:gsub("n",""):gsub(':','')
ean = params[5]:gsub("n",""):gsub(':','')
drb = params[6]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'beerk_ment ' .. fejazon .. ' ' .. cegazon .. ' ' .. cikk .. ' ' .. ean .. ' ' .. drb .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
ui:executeCommand('valueto','lmibiz', t[1]['MIBIZ'])
ui:executeCommand('valuetohidden','lfejazon', t[1]['AZON'])
result = t[1]['RESULT']
resulttext = t[1]['RESULTTEXT']
if (result=='0') then
    ui:executeCommand('TOAST','Mentés rendben.')
else
    --ui:executeCommand('TOAST','Hiba:' .. resulttext)
    ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
end
ui:executeCommand('hideobj','cap_drb;ldrb;cap_drb2;edrb2;button_ujean;lcikknev','')
ui:executeCommand('setfocus','eean', '')
ui:executeCommand('valueto','eean', '')

