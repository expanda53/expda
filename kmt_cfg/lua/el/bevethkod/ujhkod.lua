--<verzio>20170725</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
ui:executeCommand('aktbcodeobj','bcode1','')
ui:setGlobal("aktbcodeobj",'bcode1')
ui:executeCommand('valuetohidden','edrb','')
ui:executeCommand('valueto','ehkod','')
ui:executeCommand('hide','cap_drb;edrb;button_ujhkod;cikkvalpanel;cap_maxdrb;lmaxdrb','')
ui:executeCommand('enabled','ehkod','')
ui:executeCommand('setbgcolor','ehkod','#497000')
ui:executeCommand('setfocus','ehkod','')



