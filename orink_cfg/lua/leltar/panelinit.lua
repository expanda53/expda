--<verzio>20161221</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
ui:executeCommand('toast',kulsoraktar,'')
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Leltár')

str = 'leltar_mibizlist '..kezelo
t=luafunc.query_assoc(str,false)
if (t[1]['MIBIZ']~='HIBA') then
    mibiz= t[1]['MIBIZ']
    azon= t[1]['AZON']
    if (mibiz=='') then 
      mibiz='Uj bizonylat'
      azon=0
    else 
        str = 'leltar_init '.. azon .. ' ' ..kezelo
        t=luafunc.query_assoc(str,false)

    end
    ui:executeCommand('valueto','lmibiz', mibiz)
    ui:executeCommand('valueto','lfejazon', azon)
    ui:executeCommand('aktbcodeobj','bcode0','')
end
