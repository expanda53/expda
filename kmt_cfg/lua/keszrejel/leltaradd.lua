--<verzio>20180103</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
dialogres = params[2]:gsub("n",""):gsub(':','')
ui:executeCommand('valueto','lfelirmod',dialogres)

