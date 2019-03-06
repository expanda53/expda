--<verzio>20170329</verzio>
local params = {...}
ui = params[1]
ui:executeCommand("showprogress","Megnyitás...","")
ui:executeCommand("hideobj","pfooter")
kezelo = ui:getKezelo()
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)
kulsoraktar = ui:getGlobal("kulsoraktar")
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Kiadás ellenőrzés')
--str = 'ellenor_mibizlist '..kezelo .. ' ' .. kulsoraktar
--list=luafunc.query_assoc_to_str(str,false)
--luafunc.refreshtable_fromstring('mibizlist_table',list)
ui:executeCommand("showobj","mibizlistpanel")
ui:executeCommand("hideprogress","","")
