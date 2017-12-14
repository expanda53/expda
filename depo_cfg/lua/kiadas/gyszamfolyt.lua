--<verzio>20171012</verzio>
local params = {...}
ui = params[1]
mibiz = tostring(ui:findObject('lmibiz'):getText())
sorsz = tostring(ui:findObject('lsorsz'):getText())
sorsz = sorsz - 1
ui:executeCommand("hideobj","gyszamlistpanel","")
ean = tostring(ui:findObject('lean'):getText())
ui:executeCommand('startlua','kiadas/bcode1.lua', ean)



