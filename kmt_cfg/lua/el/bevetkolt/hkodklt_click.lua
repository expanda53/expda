--<verzio>20180213</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
    
function cikkUpdate(kod,nev)    
  ui:executeCommand('toast','Választott cikk:\n[' .. kod  .. '] ' .. nev,2)
  ui:executeCommand('valueto','lcikknev',nev)
  ui:executeCommand('valuetohidden','lcikod',kod)
end

row = ui:findObject('hkodklt_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
kod= t['KOD']
nev= t['CIKKNEV']
cikkUpdate(kod,nev)
ui:executeCommand('hide','hkodkltpanel','')
kulsoraktar = ui:getGlobal("kulsoraktar")
aktmodul = tostring(ui:findObject('lmodulstat'):getText())
hkod = tostring(ui:findObject('ehkregi'):getText())
      
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

