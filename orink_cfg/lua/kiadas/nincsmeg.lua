--<verzio>20161217</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
fejazon = tostring(ui:findObject('lfejazon'):getText())
lcikod = tostring(ui:findObject('lcikod'):getText())
ehkod = tostring(ui:findObject('ehkod'):getText())
ldrb2 = tostring(ui:findObject('ldrb2'):getText())
ldrb = tostring(ui:findObject('ldrb'):getText())
ui:showDialog("Biztos nincs meg?", "kiadas/mentes.lua "..fejazon .. " ".. lcikod .. " . ".. ehkod .." ".. ldrb2 .." 0 ".. ldrb .." H","")
