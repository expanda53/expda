require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]


row = ui:findObject('pcikkval_table'):getSelectedRow()  
--txt = row:toString()
--ui:executeCommand('uzenet',txt)
t = luafunc.rowtotable(row)

cegnev= t['CEGNEV']
mibiz= t['MIBIZ']
ui:executeCommand('valuetohidden','lmibiz', mibiz)
--ui:executeCommand('uzenet',cegnev .. ' ' .. mibiz)
ui:executeCommand('hideobj','pcikkval_table')
--atnezo panel
str = 'kiadas_cikklist 100 '..mibiz
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('patnezo_table',list)
ui:executeCommand("showobj","patnezo_table")

--luafunc.log(str)
