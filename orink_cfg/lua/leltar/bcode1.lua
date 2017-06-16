--<verzio>20170616</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ean = params[2]:gsub("n",""):gsub(':','')
cikk = params[3]:gsub("n",""):gsub(':','')
fejazon = params[4]:gsub("n",""):gsub(':','')
hkod = params[5]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'leltar_ean_check '..ean..' '..cikk..' ' .. fejazon .. ' ' .. hkod
t=luafunc.query_assoc(str,false)
cikknev=t[1]['CIKKNEV']
kod=t[1]['CIKK']
result=t[1]['RESULT']
drb2=t[1]['DRB2']
cikkval=0;
if (result=='0') then
    ui:executeCommand('valueto','lcikknev',cikknev)
    ui:executeCommand('valuetohidden','lcikod',kod)
    ui:executeCommand('showobj','cap_drb;cap_drb2;button_ujean','')
    ui:executeCommand('valueto','edrb','')
    ui:executeCommand('valueto','ldrb2',drb2)
    ui:executeCommand('setfocus','edrb','') 
elseif (result=='-1') then
 --ui:executeCommand('setfocus','eean','') 
 alert(ui,'Nem található termék ilyen ean kóddal:\n'..ean)
 --ui:executeCommand('valueto','eean','')
 cikkval=1
elseif (result=='-2') then
 --ui:executeCommand('setfocus','eean','') 
  alert(ui,'Több termék is található termék ilyen ean kóddal:\n'..ean)
 --ui:executeCommand('valueto','eean','')
 cikkval=2
end

if (cikkval>0) then
    if (cikkval==1) then
      ean='.'
    end
    ui:executeCommand("startlua","egyeb/cikkval_open.lua",ean)
end
