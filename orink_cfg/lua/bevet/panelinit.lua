--<verzio>20161222</verzio>
local params = {...}
ui = params[1]
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)
ui:executeCommand("hideobj","pfooter")
kezelo = ui:getKezelo()
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Beérkezés')
str = 'beerk_ceglist'
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('ceglist_table',list)
ui:executeCommand("showobj","ceglistpanel","")