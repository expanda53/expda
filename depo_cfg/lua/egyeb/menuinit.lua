--<verzio>20170718</verzio>
require 'hu.expanda.expda/LuaFunc'
params = {...}
ui = params[1]
local menuitem = params[2]:gsub(':','')
kezelo = ui:getKezelo()
ui:setGlobal("startbiz","-")
if (menuitem~='EXIT') then
  ui:executeCommand('openxml',menuitem,kezelo)
else
  ui:executeCommand('close','','')
end


