--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
kezelo = ui:getKezelo()
uzmod=ui:getGlobal("uzmod")
azon = tostring(ui:findObject('lfejazon'):getText())
hkod = tostring(ui:findObject('ehkod'):getText())
if (hkod~='') then
  --uj helykod keres eseten eloszor a regit lezarjuk (ha volt helykod, mert lehet hogy csak most inditotta a helykodot)
  str = 'leltar_hkodlist_update ' .. azon .. ' ' .. kezelo .. ' '.. hkod .. ' Z '..uzmod
  t=luafunc.query_assoc(str,false)
  result = t[1]['RESULT']
end  
--lekerdezzuk a kov. helykodot. nem szigoru, belohet mast is, ez egy ajanlas
  str = 'leltar_hkod_next ' .. azon .. ' ' .. kezelo .. ' ' .. uzmod
  t=luafunc.query_assoc(str,false)
  result = t[1]['RESULT']
  hkodnext = t[1]['HKOD']
    
ui:executeCommand('setbgcolor','ehkod','#497000')
ui:executeCommand('enabled','ehkod','')
ui:executeCommand('aktbcodeobj','bcode0','')
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valuetohidden','edot','')
ui:executeCommand('valuetohidden','eean','')
ui:executeCommand('valuetohidden','cap_rdrb','')
ui:executeCommand('valuetohidden','cap_elldrb','')
ui:executeCommand('valueto','ehkod','')
ui:executeCommand('valueto','lhkod',hkodnext)
ui:executeCommand('hide','cap_drb;edrb;cap_ean;eean;cap_dot;button_ujhkod;button_ujean;reviewpanel;button_emptyhkod','')
ui:executeCommand('setfocus','ehkod','')


