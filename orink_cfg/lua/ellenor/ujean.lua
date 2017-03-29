--<verzio>20170329</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','ldrb','0')
ui:executeCommand('valuetohidden','ldrb2','0')
ui:executeCommand('valuetohidden','ldrb4','0')
ui:executeCommand('valuetohidden','edrb2','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('hide','cap_drb;cap_edrb2;cap_drb2;button_ujean;reviewpanel;cikkvalpanel','')
ui:executeCommand('show','pfooter','')
ui:executeCommand('setfocus','eean','')