--<verzio>20171211</verzio>
require '.egyeb.functions'
local params = {...}
ui = params[1]
fejazon = params[2]:gsub("n",""):gsub(':','')
if (#params>=3) then
  dialogres = params[3]    
else
  dialogres = "null"
end  
if (dialogres=="null") then
    mibiz = tostring(ui:findObject('lmibiz'):getText())
    ui:showDialog("Biztos megszakítja a leltárt? ".. mibiz,"leltar/kesobbfolyt.lua ".. fejazon.. " igen ","leltar/kesobbfolyt.lua 0 nem")
end
if (dialogres=="igen") then
    kezelo = ui:getKezelo()
    str = 'leltar_kesobbfolyt ' .. fejazon .. ' ' .. kezelo
    t=luafunc.query_assoc(str,false)
    result = t[1]['RESULT']
    if (result=='0') then
        ui:executeCommand('TOAST','Leltár megszakítás rendben.')
    else
        alert(ui,'A leltár megszakítása során hiba történt!')
    end
    ui:executeCommand("close","","")
end    