--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('aktbcodeobj','bcode_hkod','')
ui:setGlobal("aktbcodeobj",'bcode_hkod')
ui:executeCommand('valuetohidden','edrb',0)
ui:executeCommand('valuetohidden','lmaxdrb',0)
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','elot','')
ui:executeCommand('valueto','ehkod','')
ui:executeCommand('hide','cap_lot;elot;cap_drb;button_ujhkod;cap_maxdrb;button_ujlot','')
ui:executeCommand('enabled','ehkod','')
ui:executeCommand('setbgcolor','ehkod','#497000')
ui:executeCommand('setfocus','ehkod','')



