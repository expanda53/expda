--<verzio>20170725</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
--ui:executeCommand('valuetohidden','lcikknev','')
--ui:executeCommand('valuetohidden','lcikod','')
--ui:executeCommand('valuetohidden','edrb','')
--ui:executeCommand('valueto','eean','')
--ui:executeCommand('hide','cap_drb;edrb;button_ujean;button_cikkklt;cap_maxdrb;lmaxdrb','')
--ui:executeCommand('setfocus','eean','')

ui:executeCommand('aktbcodeobj','bcode0','')
ui:setGlobal("aktbcodeobj",'bcode0')
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('valuetohidden','ehkod','')
ui:executeCommand('enabled','ehkod','')
ui:executeCommand('setbgcolor','ehkod','#497000')
ui:executeCommand('hide','cap_hkod;button_hkodlst;cap_drb;edrb;button_ujhkod;button_ujean;cikkvalpanel;cap_maxdrb;lmaxdrb;button_cikkklt','')
ui:executeCommand('enabled','eean','')
ui:executeCommand('setbgcolor','eean','#497000')
ui:executeCommand('setfocus','eean','')



