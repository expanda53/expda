require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valuetohidden','ldrb','')
ui:executeCommand('valuetohidden','ldrb2','')
ui:executeCommand('hide','cap_drb;cap_drb2;cap_gyszam;egyszam;button_gyszamlist;button_ujean;ldrb;ldrb2;reviewpanel;gyszamlistpanel','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('setfocus','eean','')

