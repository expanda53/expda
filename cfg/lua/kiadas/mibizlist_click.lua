require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]


row = ui:findObject('mibizlist_table'):getSelectedRow()  
--txt = row:toString()
--ui:executeCommand('uzenet',txt)
t = luafunc.rowtotable(row)

cegnev= t['CEGNEV']
mibiz= t['MIBIZ']
ui:executeCommand('valueto','lmibiz', mibiz)
ui:executeCommand('valueto','lcegnev', cegnev)
--ui:executeCommand('showobj','lmibiz')
--ui:executeCommand('uzenet',cegnev .. ' ' .. mibiz)
ui:executeCommand('hideobj','mibizlist_table','')


--atnezo panel
--str = 'kiadas_cikklist 100 '..mibiz
--list=luafunc.query_assoc_to_str(str,false)
--luafunc.refreshtable_fromstring('atnezo_table',list)
--ui:executeCommand("showobj","reviewpanel")

--elso kiadhato sor
str = 'kiadas_kovsor 100 '..mibiz..' 0'
t=luafunc.query_assoc(str,false)

ui:executeCommand('valueto','lcikknev', t[1]['CIKKNEV'])
ui:executeCommand('valueto','lean', t[1]['EAN'])
ui:executeCommand('valuetohidden','lsorsz', t[1]['SORSZ'])
ui:executeCommand('aktbcodeobj','bcode1','')
ui:executeCommand('showobj','eean;button_review;button_kovetkezo','')

ui:executeCommand('valuetohidden','ldrb', t[1]['DRB'])
ui:executeCommand('valuetohidden','ldrb2', t[1]['DRB2'])
ui:executeCommand('setfocus','eean','')
--luafunc.log(str)
