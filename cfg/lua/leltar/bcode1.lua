require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
mibiz = params[2]:gsub("n",""):gsub(':','')
ean = params[3]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'gyszamleltar_cikk_keres '..mibiz..' '..ean..' '..' '..kezelo
t=luafunc.query_assoc(str,false)
cikknev=t[1]['NEV']
kod=t[1]['KOD']
raktarban=t[1]['RAKTARBAN']
szamolt=t[1]['SZAMOLT']
if (cikknev~='NOTFOUND') then
    ui:executeCommand('valueto','lcikknev',cikknev)
    ui:executeCommand('valuetohidden','lcikod',kod)
    ui:executeCommand('aktbcodeobj','bcode2','')
    ui:executeCommand('showobj','cap_drb;cap_drb2;cap_gyszam;egyszam;button_gyszamlist;button_ujean','')
    ui:executeCommand('valueto','ldrb',raktarban)
    ui:executeCommand('valueto','ldrb2',szamolt)    

else
  ui:executeCommand('uzenet','Nem található termék ilyen ean kóddal:\n'..ean)
  ui:executeCommand('valueto','eean','')
  ui:executeCommand('setfocus','eean','')
end
