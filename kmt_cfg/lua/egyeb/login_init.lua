--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand('showprogress','Várjon...','')
ui:executeCommand('updatecfg','','')
ui:executeCommand('hideprogress','','')
ui:executeCommand('setfocus','elogin','')
version = ui:getAppVersion()
ui:setGlobal("appversion",version)



