--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valuetohidden','ldrb2','')
ui:executeCommand('valuetohidden','eean','')
ui:executeCommand('valueto','ecikod','')
ui:executeCommand('hide','cap_drb;cap_drb2;button_ujcikk;reviewpanel','')
ui:executeCommand('setfocus','ecikod','')



