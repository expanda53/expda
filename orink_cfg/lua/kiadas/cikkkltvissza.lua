--<verzio>20180118</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","cikkkltpanel")
ui:executeCommand("showobj","pfooter")
azon = tostring(ui:findObject('lfejazon'):getText())
--ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', azon..' . . 1')


