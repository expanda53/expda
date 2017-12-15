--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
--atnezo panel click
if (#params==1) then
  row = ui:findObject('atnezo_table'):getSelectedRow()  
  t = luafunc.rowtotable(row)
  drb= t['DRB1']
  drb2= t['DRB2']
  cikknev= t['CIKKNEV']
  hkod= t['HKOD1']
  sorsz= t['SORSZ']
  if (drb2=='') then drb2=0 end
  if (drb2~=drb) then
    ui:showDialog("A gépi és számolt mennyiség különbözik, ellenőrizted a számolt mennyiséget?\n".. cikknev .."\nHelykód:" .. hkod,"leltar/reviewclick.lua " .. sorsz,"")
  end
else
    azon = tostring(ui:findObject('lfejazon'):getText())
    sorsz = params[2]
    str = 'leltar_ellenorzes ' .. azon ..' ' .. sorsz ..' '..kezelo
    t=luafunc.query_assoc(str,false)
    result = t[1]['RESULT']
    if (result=='0') then
      ui:executeCommand('startlua','leltar/showreview.lua', "")
    else
      ui:executeCommand('toast','Megerősítés mentésekor hiba történt, mentés nem sikerült.', "")
    end
end


