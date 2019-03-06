--<verzio>20170407</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
szuro = params[2]:gsub("\n",""):gsub(':','')
fejazon = params[3]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
if (szuro=='Mind') then
  szstr='I'
else
  szstr='N'
end  
str = 'ellenor_cikklist ' .. kezelo .. ' ' .. fejazon .. ' ' ..szstr
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('atnezo_table',list)

