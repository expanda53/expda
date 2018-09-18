--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('aktbcodeobj','bcode_lot','')
ui:executeCommand('showobj','cap_lot;elot','')
ui:executeCommand('hideobj','cap_drb;cap_maxdrb;button_ujlot','')
ui:executeCommand('valuetohidden','edrb',0)
ui:executeCommand('valuetohidden','lmaxdrb',0)
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valueto','elot','') 
ui:executeCommand('setfocus','elot','') 



