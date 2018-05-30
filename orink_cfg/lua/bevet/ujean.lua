--<verzio>20180530</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','ldrb','0')
ui:executeCommand('valuetohidden','ldrb3','0')
ui:executeCommand('valuetohidden','ldrb4','0')
ui:executeCommand('valuetohidden','edrb2','')
ui:executeCommand('valuetohidden','lmegys','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('hide','cap_drb;cap_drb4;cap_drb3;cap_drb2;button_ujean;reviewpanel;cikkvalpanel;cap_megys','')
ui:executeCommand('show','pfooter','')
ui:executeCommand('setfocus','eean','')