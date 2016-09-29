require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]

--atnezo panel
mibiz = params[2]:gsub("n",""):gsub(':','')
sorsz = params[3]:gsub("n",""):gsub(':','')

str = 'kiadas_gyszamlist '..mibiz..' '..sorsz..' 100'
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('gyszam_table',list)
ui:executeCommand("showobj","gyszamlistpanel")


