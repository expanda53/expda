--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
params = {...}
ui = params[1]
local menuitem = params[2]:gsub(':','')
uzmod=''
if (#params>2) then
  uzmod = params[3]:gsub(':','')
end
if (menuitem~='EXIT') then
  ui:setGlobal("uzmod",uzmod)
  kezelo = ui:getKezelo()
  ui:executeCommand('openxml',menuitem,kezelo)
else
  ui:executeCommand('close','','')
end


