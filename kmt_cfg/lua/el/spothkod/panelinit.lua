--<verzio>20170212</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Spot leltár hkódra')
ui:executeCommand('aktbcodeobj','bcode1','')
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)