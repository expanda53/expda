--<verzio>20170718</verzio>
require 'hu.expanda.expda/LuaFunc'
params = {...}
ui = params[1]
mibiz = params[2]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'applog 0 debug bcodemenu_start_mibiz:'..mibiz
luafunc.query_assoc(str,false)

str = 'menu_barcode ' .. kezelo .. ' ' .. mibiz
t = luafunc.query_assoc(str,false)
result = t[1]['RESULT']
cegnev = t[1]['CEGNEV']
ui:executeCommand('valueto','ebcode', "")
ui:executeCommand('setfocus','ebcode', "")
ui:setGlobal("startbiz","-")
if (result~="NOTFOUND") then
    ui:setGlobal("startbiz",mibiz)
    ui:setGlobal("startceg",cegnev)
    ui:executeCommand('toast',result .."\n" .. mibiz.. "\n" .. cegnev,'')
    ui:executeCommand('openxml',result,kezelo)
else    
    ui:executeCommand('toast','nincs ilyen bizonylat:'..mibiz,'')
end    
