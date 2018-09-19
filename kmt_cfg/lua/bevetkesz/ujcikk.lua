--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('aktbcodeobj','bcode_cikk','')
ui:executeCommand('showobj','cap_cikod','')
ui:executeCommand('hideobj','cap_drb;cap_maxdrb;button_ujcikk','')
ui:executeCommand('valuetohidden','edrb',0)
ui:executeCommand('valuetohidden','lmaxdrb',0)
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valueto','ecikod','') 
ui:executeCommand('setfocus','ecikod','') 



