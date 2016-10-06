local params = {...}
ui = params[1]
ui:executeCommand("hideobj","pfooter")
kezelo = ui:getKezelo()
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Bevét')
str = 'bevet_mibizlist '..kezelo
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('mibizlist_table',list)
ui:executeCommand("showobj","mibizlist_table")