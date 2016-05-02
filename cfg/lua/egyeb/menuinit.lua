require 'hu.expanda.expda/LuaFunc'
params = {...}
ui = params[1]
local menuitem = params[2]:gsub(':','')
local kezelo = "100"
if (menuitem~='EXIT') then
  ui:executeCommand('openxml',menuitem,kezelo)
else
  ui:executeCommand('close','','')
end


