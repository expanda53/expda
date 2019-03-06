--<verzio>20170626</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
fejazon = params[2]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
--atnezo panel
str = 'hkod_cikklist '..kezelo..' '..fejazon
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('atnezo_table',list)
ui:executeCommand("showobj","reviewpanel")


