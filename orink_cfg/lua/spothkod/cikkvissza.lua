--<verzio>20170212</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","cikkvalpanel;reviewpanel;cap_drb")
ui:executeCommand("showobj","pfooter")
 ui:executeCommand('valuetohidden','edrb','')
 ui:executeCommand('valueto','eean','')
 ui:executeCommand('setfocus','eean','')   



