--<verzio>20170404</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
betuz = params[2]:gsub("\n",""):gsub(':','')
aktmodul = tostring(ui:findObject('lmodulstat'):getText())
if (aktmodul=='Kiadás ellenőrzés')  then
  azon = tostring(ui:findObject('lfejazon'):getText())
  str = 'cikkval_open '..betuz..' BFEJ.AZON='..azon
else
  str = 'cikkval_open '..betuz..' .'
end


list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('cikkval_table',list)
ui:executeCommand('setfocus','ebetuz','') 


