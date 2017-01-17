--<verzio>20170116</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Spot leltár cikkre')
ui:executeCommand('aktbcodeobj','bcode1','')
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)