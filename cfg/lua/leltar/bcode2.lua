--<verzio>20161101</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ean = params[2]:gsub("n",""):gsub(':','')
gyszam = params[3]:gsub("n",""):gsub(':','')
mibiz = params[4]:gsub("n",""):gsub(':','')
cikk = params[5]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'gyszamleltar_gyszam_ment ' .. mibiz .. ' ' .. cikk .. ' ' .. ean .. ' ' .. gyszam .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
ui:executeCommand('valueto','lmibiz', t[1]['VMIBIZ'])
ui:executeCommand('valueto','ldrb2', t[1]['DRB2'])
result = t[1]['RESULTTEXT']
if (result=='OK') then
    ui:executeCommand('TOAST','Mentés rendben.')
else
    ui:executeCommand('uzenet',result)
end
ui:executeCommand('valueto','egyszam', '')
ui:executeCommand('setfocus','egyszam', '')


