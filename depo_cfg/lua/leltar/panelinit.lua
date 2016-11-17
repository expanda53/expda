--<verzio>20161101</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Leltár')

str = 'gyszamleltar_init '..kezelo
t=luafunc.query_assoc(str,false)
if (t[1]['MIBIZ']~='HIBA') then
    mibiz= t[1]['MIBIZ']
    if (mibiz=='UJBIZ') then 
      mibiz='Uj bizonylat'
    end
    ui:executeCommand('valueto','lmibiz', mibiz)
else
end
