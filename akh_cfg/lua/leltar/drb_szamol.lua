--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
fejazon = tostring(ui:findObject('lfejazon'):getText()):gsub("n",""):gsub(':','')
cikk = tostring(ui:findObject('lcikod'):getText()):gsub("n",""):gsub(':','')
hkod = tostring(ui:findObject('ehkod'):getText()):gsub("n",""):gsub(':','')
dot = tostring(ui:findObject('edot'):getText()):gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
uzmod=ui:getGlobal("uzmod")
str = 'leltar_drb_check '..cikk..' ' .. fejazon .. ' ' .. hkod .. ' ' .. dot .. ' ' .. kezelo..' '..uzmod
t=luafunc.query_assoc(str,false)
result=t[1]['RESULT']
drb=t[1]['DRB']
biz1_drb=t[1]['BIZ1_DRB']
biz1_drb2=t[1]['BIZ1_DRB2']
biz2_drb=t[1]['BIZ2_DRB']
biz2_drb2=t[1]['BIZ2_DRB2']
if (result=='0') then
    vegell=ui:getGlobal("vegell")
    if (vegell=='V') then
        ui:executeCommand('valueto','cap_elldrb','Lelt1:' .. biz1_drb ..' Lelt2:'..biz2_drb .. ' Gép:' .. biz1_drb2)
    end
    if (drb~='0') then
      ui:executeCommand('toast','Már számolva: ' .. drb.. ' db','')
    end
    ui:executeCommand('showobj','cap_drb','')
    ui:executeCommand('valueto','cap_rdrb',drb)
    ui:executeCommand('valueto','edrb','')
    ui:executeCommand('setfocus','edrb','') 

elseif (result=='-1') then
 alert(ui,'Hiba történt a számolt darabszám lekérdezése közben:\n'..cikk)
end
