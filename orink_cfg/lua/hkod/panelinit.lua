--<verzio>20161123</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Hkód rendezés')
str = 'hkod_init '..kezelo
t=luafunc.query_assoc(str,false)
if (t[1]['AZON']~='-1') then
    mibiz= t[1]['MIBIZ']
    azon= t[1]['AZON']
else
    mibiz='Uj bizonylat'
    azon=0
end
ui:executeCommand('valueto','lmibiz', mibiz)
ui:executeCommand('valueto','lfejazon', azon)
ui:executeCommand('aktbcodeobj','bcode0','')
