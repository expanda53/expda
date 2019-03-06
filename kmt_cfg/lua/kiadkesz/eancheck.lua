--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
require '.egyeb.functions'
local params = {...}
ui=params[1]
ean = params[2]:gsub("\n",""):gsub(':','')
cikod = params[3]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
--str = "[kiadkesz_eancheck] vart:" .. cikod .. "lott:" .. ean
--alert(ui,str)
--luafunc.log(str)

if (ean==cikod) then
      ui:executeCommand('showobj','cap_drb;ldrb;cap_edrb2;edrb2','')
      ui:executeCommand('setfocus','edrb2','') 
else 
      alert(ui,'Nem egyezik a várt és a lőtt cikk!')
      ui:executeCommand('valueto','eean','') 
      ui:executeCommand('setfocus','eean','') 
end

