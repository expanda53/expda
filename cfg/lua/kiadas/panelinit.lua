local params = {...}
ui = params[1]
    
--ui:executeCommand("valueto","lstatus","frissités")
--ui:executeCommand("scanneron","","")
--ui:executeCommand('aktbcodeobj','bcode1','')
--ui:executeCommand("setfocus","lhkoc","")

str = 'kiadas_mibizlist 100'
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('pcikkval_table',list)
ui:executeCommand("showobj","pcikkval_table")