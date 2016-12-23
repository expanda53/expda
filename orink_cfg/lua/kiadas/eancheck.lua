--<verzio>20161223</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ean = params[2]:gsub("\n",""):gsub(':','')
cikod = params[3]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'ean_check '..ean
t=luafunc.query_assoc(str,false)
kod=t[1]['CIKK']
result=t[1]['RESULT']
cikkval=0;
if (result=='0') then
    if (cikod==kod) then
      ui:executeCommand('showobj','cap_drb;ldrb;cap_drb2;ldrb2;cap_edrb2;edrb2','')
      ui:executeCommand('setfocus','edrb2','') 
    else 
      alert(ui,'Nem egyezik a várt és a lőtt cikk!')
      ui:executeCommand('valueto','eean','') 
      ui:executeCommand('setfocus','eean','') 
    end
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
    --if (cikkval==1) then
      --ean='.'
    --end
    --ui:executeCommand("startlua","egyeb/cikkval_open.lua",ean)
      ui:executeCommand('valueto','eean','') 
      ui:executeCommand('setfocus','eean','') 
end
