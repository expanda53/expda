--<verzio>20161121</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','ldrb','0')
ui:executeCommand('valuetohidden','edrb2','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('hide','cap_drb;ldrb;cap_drb2;edrb2;button_ujean;reviewpanel;cikkvalpanel','')
ui:executeCommand('setfocus','eean','')