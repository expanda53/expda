--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valuetohidden','edot','')
ui:executeCommand('valuetohidden','cap_rdrb','')
ui:executeCommand('valuetohidden','cap_elldrb','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('hide','cap_drb;cap_dot;button_ujean;reviewpanel','')
ui:executeCommand('setfocus','eean','')



