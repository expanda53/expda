--<verzio>20180103</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valuetohidden','ldrb2','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('hide','lfelirmod;cap_drb;cap_drb2;edrb;ldrb2;button_ujean;reviewpanel','')
ui:executeCommand('setfocus','eean','')



