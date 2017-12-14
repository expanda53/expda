--<verzio>20161102</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
focused = params[2]
--:gsub("n",""):gsub(':','')
ui:executeCommand('setfocus',focused,'')

