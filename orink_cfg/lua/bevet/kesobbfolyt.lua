--<verzio>20161201</verzio>
local params = {...}
ui = params[1]
fejazon = params[2]:gsub("n",""):gsub(':','')
kezelo = ui:getKezelo()
str = 'beerk_kesobbfolyt ' .. fejazon .. ' ' .. kezelo
t=luafunc.query_assoc(str,false)
result = t[1]['RESULT']
resulttext = t[1]['RESULTTEXT']
if (result=='0') then
    ui:executeCommand('TOAST','Beérkezés megszakítás rendben.')
else
    ui:executeCommand('playaudio','alert.mp3','')
    ui:executeCommand('TOAST','Hiba:' .. resulttext)
end
ui:executeCommand("close","","")