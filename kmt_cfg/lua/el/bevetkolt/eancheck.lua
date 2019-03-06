--<verzio>20180213</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ean = params[2]:gsub("\n",""):gsub(':','')
azon = params[3]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
hkod = tostring(ui:findObject('ehkregi'):getText())
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
    
    str = 'hkod_cikkhkklt ' .. hkod .. ' ' .. kod .. ' ' .. kulsoraktar
    t2=luafunc.query_assoc(str,false)
    maxkidrb=t2[1]['MAXKIDRB']
    ui:executeCommand('valueto','lmaxdrb',maxkidrb)
    ui:executeCommand('showobj','cap_maxdrb;pfooter;button_ujean;cap_hkod;button_cikkklt','')      
    ui:executeCommand('disabled','eean','')
    ui:executeCommand('setbgcolor','eean','#434343')

    ui:executeCommand('aktbcodeobj','bcode1','')
    ui:setGlobal("aktbcodeobj",'bcode1')
    ui:executeCommand('valuetohidden','edrb','')
    ui:executeCommand('valueto','ehkod','')
    ui:executeCommand('hide','cap_drb;edrb;cikkvalpanel','')
    ui:executeCommand('enabled','ehkod','')
    ui:executeCommand('setbgcolor','ehkod','#497000')
    ui:executeCommand('setfocus','ehkod','')

      
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
