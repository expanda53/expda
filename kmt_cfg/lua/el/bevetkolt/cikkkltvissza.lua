--<verzio>20170815</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","cikkkltpanel")
ui:executeCommand("showobj","pfooter")
aktbcodeobj = ui:getGlobal("aktbcodeobj")
ui:executeCommand('aktbcodeobj',aktbcodeobj,'')
if (aktbcodeobj=='bcode1') then
    ui:executeCommand('setfocus','edrb','') 
    ui:executeCommand('showobj','pfooter','')
    
else
    ui:executeCommand('setfocus','ehkod','') 
    ui:executeCommand('showobj','pfooter','')
end


