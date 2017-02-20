--<verzio>20170220</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
umod = params[2]:gsub("\n",""):gsub(':','')
if (umod=='drb') then
  umod='auto'
  caption='Mód:auto'
else
  umod='drb'
  caption='Mód:drb'
end  
ui:executeCommand('valuetohidden','lbevmod',umod)
ui:executeCommand('valueto','button_bevmod',caption)
