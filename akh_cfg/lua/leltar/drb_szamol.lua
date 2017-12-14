--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
fejazon = tostring(ui:findObject('lfejazon'):getText()):gsub("n",""):gsub(':','')
cikk = tostring(ui:findObject('lcikod'):getText()):gsub("n",""):gsub(':','')
hkod = tostring(ui:findObject('ehkod'):getText()):gsub("n",""):gsub(':','')
dot = tostring(ui:findObject('edot'):getText()):gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'leltar_drb_check '..cikk..' ' .. fejazon .. ' ' .. hkod .. ' ' .. dot .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
result=t[1]['RESULT']
drb=t[1]['DRB']
if (result=='0') then
    ui:executeCommand('showobj','cap_drb','')
    ui:executeCommand('valueto','cap_rdrb',drb)
    ui:executeCommand('valueto','edrb','')
    ui:executeCommand('setfocus','edrb','') 
elseif (result=='-1') then
 alert(ui,'Hiba történt a számolt darabszám lekérdezése közben:\n'..cikk)
end
