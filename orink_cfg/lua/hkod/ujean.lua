--<verzio>20161117</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('hide','cap_drb;edrb;button_ujean;reviewpanel;cap_maxdrb;lmaxdrb','')
ui:executeCommand('setfocus','eean','')



