--<verzio>20180213</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('aktbcodeobj','bcode_ean','')
ui:setGlobal("aktbcodeobj",'bcode_ean')
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('valuetohidden','ehkod','')
ui:executeCommand('enabled','ehkod','')
ui:executeCommand('setbgcolor','ehkod','#497000')
ui:executeCommand('hide','cap_hkod;cap_drb;edrb;button_ujean;cikkvalpanel;cap_maxdrb;lmaxdrb;button_cikkklt','')
ui:executeCommand('enabled','eean','')
ui:executeCommand('setbgcolor','eean','#497000')
ui:executeCommand('setfocus','eean','')



