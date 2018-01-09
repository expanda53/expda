--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('startlua','egyeb/numeric_panel.lua', "show ecikknev print/cikk_keres.lua Cikknév")
