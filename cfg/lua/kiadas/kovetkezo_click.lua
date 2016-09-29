require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
mibiz = params[2]:gsub("n",""):gsub(':','')
sorsz = params[3]:gsub("n",""):gsub(':','')
--elso kiadhato sor
str = 'kiadas_kovsor 100 '..mibiz..' ' ..sorsz
t=luafunc.query_assoc(str,false)

if (t[1]['SORSZ']>'0') then
ui:executeCommand('valueto','lcikknev', t[1]['CIKKNEV'])
ui:executeCommand('valueto','lean', t[1]['EAN'])
ui:executeCommand('valuetohidden','lsorsz', t[1]['SORSZ'])
ui:executeCommand('aktbcodeobj','bcode1','')
--ui:executeCommand('showobj','eean;button_review;button_kovetkezo','')

ui:executeCommand('valuetohidden','ldrb', t[1]['DRB'])
ui:executeCommand('valuetohidden','ldrb2', t[1]['DRB2'])
ui:executeCommand('setfocus','eean','')
else
ui:executeCommand('uzenet','Nincs több kiszedendő tétel!','')
end
--luafunc.log(str)
