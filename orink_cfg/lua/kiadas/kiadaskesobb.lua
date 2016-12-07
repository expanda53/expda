--<verzio>20161206</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
fejazon = tostring(ui:findObject('lfejazon'):getText())
str = 'kiadas_kesobb '..kezelo..' '..fejazon
t=luafunc.query_assoc(str,false)
result=t[1]['RESULT']
resulttext=t[1]['RESULTTEXT']
if (result=='0') then
   ui:executeCommand('toast','Kiszedés megszakítása rendben.','')
else
  ui:executeCommand('toast',resulttext,'')
end
ui:executeCommand("close","","")