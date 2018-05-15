--<verzio>20180514</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ean = params[2]:gsub("\n",""):gsub(':','')
aktmodul = tostring(ui:findObject('lmodulstat'):getText())
if (aktmodul=='Kiadás ellenőrzés')  then
  azon = tostring(ui:findObject('lfejazon'):getText())
  str = 'cikkval_open '..ean..' BFEJ.AZON='..azon
elseif (aktmodul=='Hkód rendezés') then
    hkod = tostring(ui:findObject('ehkod'):getText())
    str = 'cikkval_open '..ean..' HKOD=' .. hkod
else
    str = 'cikkval_open '..ean..' .'
end
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('cikkval_table',list)
ui:executeCommand('hide','pfooter','')
ui:executeCommand('show','cikkvalpanel','')
if (ean=='.') then ean='' end
ui:executeCommand('valueto','ebetuz',ean)
ui:executeCommand('setfocus','ebetuz','') 