--<verzio>20170725</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ean = params[2]:gsub("\n",""):gsub(':','')
hkod = params[3]:gsub("\n",""):gsub(':','')
azon = params[4]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
str = 'ean_check '..ean
t=luafunc.query_assoc(str,false)
cikknev=t[1]['CIKKNEV']
kod=t[1]['CIKK']
result=t[1]['RESULT']
cikkval=0;
if (result=='0') then
    ui:executeCommand('valueto','lcikknev',cikknev)
    ui:executeCommand('valueto','lcikknevp',cikknev)
    ui:executeCommand('valuetohidden','lcikod',kod)
    ui:executeCommand('showobj','cap_drb;edrb;button_ujean;button_cikkklt','')
    szorzo = 1

    str = 'hkod_cikkhkklt '..hkod..' '..kod .. ' ' .. kulsoraktar
    t2=luafunc.query_assoc(str,false)
    maxkidrb=t2[1]['MAXKIDRB']

    str = 'hkod_kocsiklt '..azon..' '..kod
    t2=luafunc.query_assoc(str,false)
    maxbedrb=t2[1]['DRB']

    ui:executeCommand('valueto','lmaxdrb',maxbedrb)
    ui:executeCommand('showobj','cap_maxdrb','')

    ui:executeCommand('startlua','bevethkod/cikkklt.lua',kod)
    --ui:executeCommand('setfocus','edrb','') 
elseif (result=='-1') then
 --ui:executeCommand('setfocus','eean','') 
 alert(ui,'Nem található termék ilyen ean kóddal:\n'..ean)
 ui:executeCommand('hideobj','cap_maxdrb;lmaxdrb;cap_drb;edrb;button_cikkklt;lcikknev','')
 ui:executeCommand('showobj','button_ujean','')
 ui:executeCommand('valueto','eean','')
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
    ui:executeCommand("hideobj","cikkkltpanel")
    ui:executeCommand("startlua","egyeb/cikkval_open.lua",ean)
end
