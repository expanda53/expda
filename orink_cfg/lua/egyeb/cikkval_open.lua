--<verzio>20161201</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ean = params[2]:gsub("\n",""):gsub(':','')
str = 'cikkval_open '..ean
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('cikkval_table',list)
ui:executeCommand('show','cikkvalpanel','')
if (ean=='.') then ean='' end
ui:executeCommand('valueto','ebetuz',ean)
ui:executeCommand('setfocus','ebetuz','') 