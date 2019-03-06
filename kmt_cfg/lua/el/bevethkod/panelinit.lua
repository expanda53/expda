--<verzio>20170725</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
--kulsoraktar = ui:getGlobal("kulsoraktar")
kulsoraktar="RA01"
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Beérkezés elrakodás')
str = 'hkod_init '..kezelo .. ' ' .. kulsoraktar
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
ui:setGlobal("aktbcodeobj",'bcode0')
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)