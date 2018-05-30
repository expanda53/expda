--<verzio>20180530</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
dialogres = params[2]:gsub("\n",""):gsub(':','')
if (dialogres=="null") then
    ui:showDialog("Menti az EAN-t a kiválasztott cikkhez?","bevet/cikkval_init.lua igen","bevet/cikkval_init.lua nem")
end
if (dialogres=="igen") then
    ui:executeCommand("startlua","egyeb/cikkval_open.lua",'.')
    
end      
if (dialogres=="nem") then
   ui:executeCommand('valueto','eean','') 
   ui:executeCommand("startlua","egyeb/cikkval_open.lua",'.')
end 
