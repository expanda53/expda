require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]

--atnezo panel
mibiz = tostring(ui:findObject('lmibiz'):getText())
str = 'kiadas_cikklist 100 '..mibiz
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('atnezo_table',list)
ui:executeCommand("showobj","reviewpanel")


