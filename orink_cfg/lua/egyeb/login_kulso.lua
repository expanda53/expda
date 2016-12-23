--<verzio>20161222</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kulsostr = params[2]:gsub("%%20"," "):gsub(":","")
kulso=""
if (kulsostr=="Külső raktár") then
  kulso="RA04"
else
  kulso="RA01"
end
ui:setGlobal("kulsoraktar",kulso)

