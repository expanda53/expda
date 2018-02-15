--<verzio>20180213</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
--kulsoraktar = ui:getGlobal("kulsoraktar")
kulsoraktar="RA01"
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Költözés')
mibiz='Uj bizonylat'
azon=0
ui:executeCommand('valueto','lmibiz', mibiz)
ui:executeCommand('valueto','lfejazon', azon)
ui:executeCommand('aktbcodeobj','bcode_hkregi','')
ui:setGlobal("aktbcodeobj",'bcode_hkregi')
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)
ui:executeCommand('setbgcolor','ehkregi','#497000')