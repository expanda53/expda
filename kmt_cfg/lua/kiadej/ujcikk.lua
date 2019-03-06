--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('aktbcodeobj','bcode2','')
ui:executeCommand('disabled','ehkod','')
ui:executeCommand('setbgcolor','ehkod','#434343')
ui:executeCommand('showobj','cap_ean;eean','')
ui:executeCommand('valuetohidden','edrb2','')
ui:executeCommand('valuetohidden','lcikknev','')
ui:executeCommand('hideobj','cap_edrb2;button_ujcikk','')
ui:executeCommand('valueto','eean','')
ui:executeCommand('setfocus','eean','')
