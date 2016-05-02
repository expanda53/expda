require 'model/Luafunc'
local params = {...}
ui=params[1]
hkodc = params[2]:gsub(':','')
--lehetne ellenorizni a hkodot, egyelore ellenorzes nelkul elfogadjuk

ui:executeCommand('setbgcolor','lhklabel','lightgray')
ui:executeCommand('setbgcolor','lcikklabel','green')
ui:executeCommand('valueto','lcikkc','')
ui:executeCommand('showobj','lcikklabel;bujhkod','')
ui:executeCommand('setfocus','lcikkc','')
ui:executeCommand('valueto','lstatus','Cikk lövés')
ui:executeCommand('aktbcodeobj','bcode2','')
ui:executeCommand('scanneron','','')
