--<verzio>20170223</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","cikkkltpanel")
ui:executeCommand("showobj","pfooter")
ui:setGlobal("aktbcodeobj",'bcode1')
ui:executeCommand("setfocus","edrb")


