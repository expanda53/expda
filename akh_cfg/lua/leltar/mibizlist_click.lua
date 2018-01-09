--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
azon = params[2]
if (azon=='0') then
    row = ui:findObject('mibizlist_table'):getSelectedRow()  
    t = luafunc.rowtotable(row)
    mibiz= t['MIBIZ']
    stat6= t['STAT6']
    azon= t['AZON']
else
    mibiz = params[3]
    stat6 = params[4]
end    
ui:setGlobal("vegell",stat6)
ui:executeCommand('valuetohidden','lfejazon', azon)
ui:executeCommand('valueto','lmibiz',mibiz)
ui:executeCommand('hideobj','mibizlistpanel','')
ui:executeCommand('showobj','pfooter;button_review;cap_hkod;lhkod;ehkod','')
ui:executeCommand('startlua','leltar/ujhkod.lua', "")



