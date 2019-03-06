--<verzio>20170117</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('valuetohidden','lcikod','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('hide','button_ujean;button_cikkklt','')
ui:executeCommand('setfocus','eean','')



