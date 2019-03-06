--<verzio>20180103</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('setbgcolor','ehkod','#497000')
ui:executeCommand('enabled','ehkod','')
ui:executeCommand('aktbcodeobj','bcode0','')
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valuetohidden','eean','')
ui:executeCommand('valueto','ehkod','')
ui:executeCommand('hide','cap_drb;edrb;cap_ean;eean;button_ujhkod;button_ujean;reviewpanel;cikkvalpanel;button_cikkval;cap_drb2;ldrb2;lfelirmod','')
ui:executeCommand('setfocus','ehkod','')


