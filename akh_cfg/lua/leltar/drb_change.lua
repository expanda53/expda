--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ui:executeCommand('showobj','cap_dot;edot','')
ui:executeCommand('setfocus','edot','') 
