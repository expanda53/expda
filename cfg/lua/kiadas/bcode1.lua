require 'model/Luafunc'
local params = {...}
ui=params[1]
hkodc = params[2]:gsub(':','')
--lehetne ellenorizni a hkodot, egyelore ellenorzes nelkul elfogadjuk

ui:executeCommand('aktbcodeobj','bcode2','')
ui:executeCommand('scanneron','','')
