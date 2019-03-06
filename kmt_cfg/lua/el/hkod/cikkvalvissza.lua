--<verzio>20170223</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","cikkvalpanel")
ui:executeCommand("showobj","pfooter")
ui:executeCommand("setfocus","eean")
ui:setGlobal("aktbcodeobj",'bcode1')


