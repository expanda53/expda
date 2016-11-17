--<verzio>20161101</verzio>
local params = {...}
ui = params[1]
ui:executeCommand("valueto","egyszam","")
ui:executeCommand("valueto","eean","")
ui:executeCommand("valuetohidden","lcikod","")
ui:executeCommand('hideobj','cap_drb;cap_drb2;ldrb;ldrb2;cap_gyszam;egyszam;button_gyszamlist;button_ujean;reviewpanel;gyszamlistpanel','')
ui:executeCommand("setfocus","eean","")
