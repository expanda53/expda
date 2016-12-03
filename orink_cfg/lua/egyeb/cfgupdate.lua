--<verzio>20161203</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
if (kezelo=='100') then
  ui:executeCommand('updatecfg','','')
end

