--<verzio>20170116</verzio>
params = {...}
ui = params[1]
require 'hu.expanda.expda/LuaFunc'
kezelo = ui:getKezelo()
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)



