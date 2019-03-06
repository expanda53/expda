--<verzio>20170223</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","hkodkltpanel")
ui:executeCommand("showobj","pfooter")
aktbcodeobj = ui:getGlobal("aktbcodeobj")
ui:executeCommand('aktbcodeobj',aktbcodeobj,'')
if (aktbcodeobj=='bcode1') then
  ui:executeCommand('setfocus','eean','')
elseif (aktbcodeobj=='bcode0') then
  ui:executeCommand('startlua','hkod/ujhkod.lua','')
end  
--ui:executeCommand('toast',aktbcodeobj,'')


