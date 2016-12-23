--<verzio>20161221</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]


row = ui:findObject('mibizlist_table'):getSelectedRow()  
--txt = row:toString()
--ui:executeCommand('uzenet',txt)
t = luafunc.rowtotable(row)

cegnev= t['CEGNEV']
mibiz= t['MIBIZ']
azon= t['AZON']
kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
str = 'kiadas_init '..azon..' '..kezelo.. ' ' .. kulsoraktar
q=luafunc.query_assoc(str,false)
if (q[1]['RESULT']~='0') then
    text = q[1]['RESULTTEXT']
    ui:executeCommand('uzenet',text, '')
else
    ui:executeCommand('valuetohidden','lfejazon', azon)
    ui:executeCommand('valueto','lmibiz', mibiz)
    ui:executeCommand('valueto','lcegnev', cegnev)
    ui:executeCommand('hideobj','mibizlistpanel','')

    ui:executeCommand('showobj','pfooter;button_review','')
    ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', azon..' . . 1')
    ui:executeCommand('aktbcodeobj','bcode1','')
end


