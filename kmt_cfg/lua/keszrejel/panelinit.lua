--<verzio>20180911</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Készre jelentés')
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)
ui:executeCommand("hideobj","pfooter")
str = 'keszrejel_mibizlist '..kezelo
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('bizlist_table',list)
ui:executeCommand('show','bizlist_table','')
ui:executeCommand("showobj","bizlistpanel","")

--ui:executeCommand('valuetohidden','lfejazon', 0)
--ui:executeCommand('valueto','lmibiz', 'Új bizonylat')
--ui:executeCommand('showobj','cap_cikod;ecikod;button_review','')
--ui:executeCommand('aktbcodeobj','bcode0','')

