--<verzio>20171211</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
ui:executeCommand("showprogress","Megnyitás...","")
ui:executeCommand('aktbcodeobj','bcode0','')
ui:executeCommand("hideprogress","","")

