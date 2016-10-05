require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = params[2]:gsub("n",""):gsub(':','')
ui:executeCommand('openxml','mainmenu.xml',kezelo)