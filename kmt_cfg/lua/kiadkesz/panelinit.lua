--<verzio>20180911</verzio>
local params = {...}
ui = params[1]
ui:executeCommand("showprogress","Megnyitás...","")
ui:executeCommand("hideobj","pfooter")
kezelo = ui:getKezelo()
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Készáru Eladás')

str = 'kiadkesz_mibizlist '..kezelo
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('mibizlist_table',list)
ui:executeCommand("showobj","mibizlistpanel","")

ui:executeCommand("hideprogress","","")
