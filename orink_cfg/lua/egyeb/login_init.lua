--<verzio>20161221</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand('showprogress','Várjon...','')
ui:executeCommand('updatecfg','','')
ui:executeCommand('hideprogress','','')
ui:executeCommand('setfocus','elogin','')
ui:setGlobal("kulsoraktar","RA01")
version = ui:getAppVersion()
ui:setGlobal("appversion",version)



