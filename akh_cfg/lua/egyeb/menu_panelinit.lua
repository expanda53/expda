--<verzio>20161221</verzio>
params = {...}
ui = params[1]
require 'hu.expanda.expda/LuaFunc'
--imei = ui:getImei()
--mac = ui:getMacAddress()
--ui:executeCommand('toast','imei:' .. imei ..', mac:' .. mac,'')
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
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)




