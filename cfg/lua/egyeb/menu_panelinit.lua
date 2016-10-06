params = {...}
ui = params[1]
require 'hu.expanda.expda/LuaFunc'
wifienabled = ui:isWifiEnabled()
wfs = ui:getWifiStrength()
if (wifienabled and wfs>0) then 
  ui:executeCommand('toast','wifi ok','')
else
  if (wifienabled)  then 
    ui:showMessage('no wifi signal')
  else
    ui:showMessage('wifi not enabled')
  end
end
kezelo = ui:getKezelo()
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)



