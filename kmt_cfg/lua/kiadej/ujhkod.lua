--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand('enabled','ehkod','')
ui:executeCommand('setbgcolor','ehkod','#497000')
ui:executeCommand('showobj','cap_hkod','')
ui:executeCommand('valueto','ehkod', '')
ui:executeCommand('valuetohidden','eean', '')
ui:executeCommand('aktbcodeobj','bcode1','')
ui:executeCommand('hideobj','cap_edrb2;cap_ean;eean','')
ui:executeCommand('setfocus','ehkod','')