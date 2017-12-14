--<verzio>20171012</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand('showobj','pfooter;button_review;button_kovetkezo','')
ui:executeCommand('aktbcodeobj','bcode1','')
ui:executeCommand('hideobj','cap_drb;ldrb;cap_drb2;ldrb2;cap_gyszam;egyszam;button_gyszamlist;reviewpanel','')
ui:executeCommand('valueto','lean', 'EAN kód lövés')
ui:executeCommand('valuetohidden','lcikknev', '')
ui:executeCommand('valuetohidden','egyszam', '')
ui:executeCommand('valueto','eean', '')
ui:executeCommand('setfocus','eean','')
--luafunc.log(str)
