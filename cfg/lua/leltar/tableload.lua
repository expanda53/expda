require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
sordb = ui:findObject('esordb'):getText():toString()
str = 'mantis_summary ' .. sordb
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('pcikkval_table',list)
