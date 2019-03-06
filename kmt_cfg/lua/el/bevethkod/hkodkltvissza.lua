--<verzio>20170725</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","hkodkltpanel")
ui:executeCommand("showobj","pfooter")
aktbcodeobj = ui:getGlobal("aktbcodeobj")
ui:executeCommand('aktbcodeobj',aktbcodeobj,'')
if (aktbcodeobj=='bcode1') then
  ui:executeCommand('setfocus','ehkod','')
elseif (aktbcodeobj=='bcode0') then
  ui:executeCommand('startlua','bevethkod/ujean.lua','')
end  
--ui:executeCommand('toast',aktbcodeobj,'')


