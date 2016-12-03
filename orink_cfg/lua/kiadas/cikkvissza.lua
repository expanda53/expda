--<verzio>20161203</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","cikkvalpanel")
ui:executeCommand("showobj","pfooter")
ui:executeCommand('valueto','eean','') 
ui:executeCommand('setfocus','eean','') 



