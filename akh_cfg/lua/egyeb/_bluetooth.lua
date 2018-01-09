--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
fn = params[2]
kezelo = ui:getKezelo()
if (fn=='init') then
  --btlist = luafunc.btdevlist_tostr()
  t = luafunc.btdevlist()
  rows=""
  for i, r in ipairs(t) do
    if (r['CLASS'] == "1664") then
      col="[[MAC=" .. r['MAC'] .. "|@@style:listtitle;listtitledone]][[NAME=" .. r['NAME'] .. "|@@style:listtitle;listtitledone]][[CLASS=" .. r['CLASS'] .. "|@@style:listtitle;listtitledone]]\n"
      rows=rows .. col
    end
  end
  
  luafunc.refreshtable_fromstring('devlist_table',rows)
  ui:executeCommand('show','devlistpanel;devlist_table','')  
end

if (fn=='click') then
  row = ui:findObject('devlist_table'):getSelectedRow()  
  t = luafunc.rowtotable(row)
  mac= t['MAC']
  res = luafunc.btconnect(mac)
  if (res==true) then
    msg="A Bluetooth kapcsolat létrejött"
    fn='hide';
  else
    msg="A Bluetooth kapcsolat létrehozása sikertelen"
  end
  ui:executeCommand('toast',msg,'')  
end

if (fn=='close') then
  res = luafunc.btclose()
end
if (fn=='hide') then
  ui:executeCommand("close","","")
  ui:executeCommand('openxml','mainmenu.xml',kezelo)
  
  
end

