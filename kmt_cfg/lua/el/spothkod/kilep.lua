--<verzio>20170214</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
dialogres = params[2]
if (dialogres=="null") then
      ui:showDialog("Biztos megszakítja és újrakezdi a spotleltárt?","spothkod/kilep.lua igen ","spothkod/kilep.lua nem")
elseif (dialogres=="igen") then
      ui:executeCommand("close","","")
end
