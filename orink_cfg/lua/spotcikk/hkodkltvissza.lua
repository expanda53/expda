--<verzio>20170117</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","cikkkltpanel;cikkvalpanel")
ui:executeCommand("showobj","pfooter")


