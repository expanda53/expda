--<verzio>20161221</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kulso = params[2]    
ui:setGlobal("kulsoraktar",kulso)
ui:executeCommand('toast',kulso,'')
