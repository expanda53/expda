--<verzio>20170725</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ean = params[2]:gsub("\n",""):gsub(':','')
azon = params[3]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
hkodbe="B00000"
kulsoraktar = ui:getGlobal("kulsoraktar")
str = 'ean_check '..ean
t=luafunc.query_assoc(str,false)
cikknev=t[1]['CIKKNEV']
kod=t[1]['CIKK']
result=t[1]['RESULT']
cikkval=0;
if (result=='0') then
    ui:executeCommand('valueto','lcikknev',cikknev)
    ui:executeCommand('valuetohidden','lcikod',kod)
    
      ui:executeCommand('aktbcodeobj','bcode1','')
      ui:executeCommand('disabled','eean','')
      ui:executeCommand('setbgcolor','eean','#434343')
      ui:executeCommand('showobj','cap_hkod;ehkod;button_ujean;button_hkodlst;button_cikkklt','')
      
      -- kiadhato keszlet mindig a B00000 hkod keszlete
      hkodbe='B00000'
      str = 'hkod_cikkhkklt ' .. hkodbe .. ' ' .. kod .. ' ' .. kulsoraktar
      t2=luafunc.query_assoc(str,false)
      maxkidrb=t2[1]['MAXKIDRB']
      ui:executeCommand('valueto','lmaxdrb',maxkidrb)
      ui:executeCommand('showobj','cap_maxdrb','')      

      
      ui:executeCommand('setfocus','ehkod','')
      ui:setGlobal("aktbcodeobj",'bcode1')  
      ui:executeCommand('startlua','bevethkod/cikkklt.lua',kod)      
      
elseif (result=='-1') then
 --ui:executeCommand('setfocus','eean','') 
 alert(ui,'Nem található termék ilyen ean kóddal:\n'..ean)
 ui:executeCommand('hideobj','cap_maxdrb;lmaxdrb;cap_drb;edrb;button_cikkklt;lcikknev','')
 ui:executeCommand('showobj','button_ujean','')
 --ui:executeCommand('valueto','eean','')
 cikkval=1
elseif (result=='-2') then
 --ui:executeCommand('setfocus','eean','') 
 alert(ui,'Több termék is található termék ilyen ean kóddal:\n'..ean)
 ui:executeCommand('hideobj','cap_maxdrb;lmaxdrb;cap_drb;edrb;button_cikkklt;lcikknev','')
 ui:executeCommand('showobj','button_ujean','')
 --ui:executeCommand('valueto','eean','')
 cikkval=2
end

if (cikkval>0) then
    if (cikkval==1) then
      ean='.'
    end
    ui:executeCommand("startlua","egyeb/cikkval_open.lua",ean)
end
