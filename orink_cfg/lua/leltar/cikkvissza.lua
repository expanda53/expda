--<verzio>20161206</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","cikkvalpanel")
ui:executeCommand("showobj","pfooter")



