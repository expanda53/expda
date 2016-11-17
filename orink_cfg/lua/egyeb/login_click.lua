--<verzio>20161117</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = params[2]:gsub("n",""):gsub(':','')
str = 'login_check '..kezelo
t=luafunc.query_assoc(str,false)
if (t[1]['RESULTTEXT']=='OK') then
    ui:executeCommand("valueto","elogin","")
    ui:executeCommand('openxml','mainmenu.xml',kezelo)
else
    ui:executeCommand("toast","Nem megfelelő bejelentkezési adatok!","")
    ui:executeCommand("valueto","elogin","")
    ui:executeCommand("setfocus","elogin","")
end