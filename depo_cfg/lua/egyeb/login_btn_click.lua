--<verzio>20161101</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
chr = params[2]:gsub("n",""):gsub(':','')
loginstr = tostring(ui:findObject('elogin'):getText())
if (chr=='DEL') then
  strlen = loginstr:len()
  if (strlen>0) then
    loginstr = loginstr:sub(1,strlen - 1)
  end
else
  loginstr = loginstr .. chr
end
ui:executeCommand("valueto","elogin",loginstr)
ui:executeCommand("setfocus","elogin","")
