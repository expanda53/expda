--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
hkod = tostring(ui:findObject('ehkod'):getText()):gsub("n",""):gsub(':','')
cikk = tostring(ui:findObject('ecikknev'):getText()):gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
if (hkod=='' and cikk=='') then
    ui:executeCommand('toast','Vagy helykód vagy a cikk név kezdet legyen megadva!','')
else
  if (cikk~='' and hkod=='' and cikk:len()<5) then
    ui:executeCommand('toast','A cikk név kezdet legalább 5 karakter!','')
  else
    str = 'print_cikklist ' .. hkod ..' ' .. cikk .. ' ' ..kezelo
    list=luafunc.query_assoc_to_str(str,false)
    if (list~=nil) then
       luafunc.refreshtable_fromstring('atnezo_table',list)
       ui:executeCommand('show','atnezo_table','')
    else
       ui:executeCommand('hide','atnezo_table','')
       ui:executeCommand('toast','Nem található cikk!','')
    end
  end
end    
