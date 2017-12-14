--<verzio>20171012</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ean = params[2]:gsub("n",""):gsub(':','')
mibiz = tostring(ui:findObject('lmibiz'):getText())
kezelo = ui:getKezelo()
str = 'kiadas_eankeres '..kezelo..' '..mibiz..' ' ..ean
t=luafunc.query_assoc(str,false)

if (t[1]['SORSZ']>'0') then
    ui:executeCommand('valueto','lcikknev', t[1]['CIKKNEV'])
    ui:executeCommand('valueto','lean', ean)
    ui:executeCommand('valuetohidden','lsorsz', t[1]['SORSZ'])
    ui:executeCommand('valuetohidden','ldrb', t[1]['DRB'])
    ui:executeCommand('valuetohidden','ldrb2', t[1]['DRB2'])
    if (t[1]['DRB2']=='0') then
      ui:executeCommand('hideobj','button_gyszamlist', '')
    else
      ui:executeCommand('showobj','button_gyszamlist', '')
    end
    ui:executeCommand('showobj','cap_drb;ldrb;cap_drb2;ldrb2;cap_gyszam;egyszam','')
    ui:executeCommand('setfocus','egyszam', '')
    ui:executeCommand('aktbcodeobj','bcode2','')
else
  ui:executeCommand('uzenet','Nem található a bizonylaton ilyen EAN!\n'..ean,"egyeb/setfocus.lua eean")
  ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', '')
end

--ui:executeCommand('scanneron','','')
