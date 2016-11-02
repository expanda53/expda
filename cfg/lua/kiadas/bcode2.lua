--<verzio>20161102</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ean = params[2]:gsub("n",""):gsub(':','')
gyszam = params[3]:gsub("n",""):gsub(':','')
mibiz = params[4]:gsub("n",""):gsub(':','')
sorsz = params[5]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'kiadas_gyszam_ment ' .. mibiz .. ' ' .. sorsz .. ' ' .. ean .. ' ' .. gyszam .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
ui:executeCommand('valueto','ldrb2', t[1]['DRB2'])
result = t[1]['RESULTTEXT']
if (result=='OK') then
    ui:executeCommand('showobj','button_gyszamlist','')
    ui:executeCommand('TOAST','Mentés rendben.')
else
    ui:executeCommand('uzenet',result,"egyeb/setfocus.lua egyszam")
end
ui:executeCommand('valueto','egyszam', '')
ui:executeCommand('setfocus','egyszam', '')


