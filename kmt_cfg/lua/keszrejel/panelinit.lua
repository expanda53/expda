--<verzio>20180911</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Készre jelentés')
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)
str = 'keszrejel_mibizlist '..kezelo
t=luafunc.query_assoc(str,false)
if (t[1]['MIBIZ']~='HIBA') then
    mibiz= t[1]['MIBIZ']
    azon= t[1]['AZON']
    ui:executeCommand('valueto','lmibiz', mibiz)
    ui:executeCommand('valuetohidden','lfejazon', azon)
    ui:executeCommand('aktbcodeobj','bcode0','')
end
