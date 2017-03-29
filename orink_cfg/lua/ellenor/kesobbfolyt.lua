--<verzio>20170329</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
if (#params>=2) then
  dialogres = params[2]    
else
  dialogres = "null"
end  

if (dialogres=="null") then
    mibiz = tostring(ui:findObject('lmibiz'):getText())
    ui:showDialog("Biztos megszakítja a kiszedés ellenőrzést? ".. mibiz,"ellenor/kesobbfolyt.lua igen ","ellenor/kesobbfolyt.lua nem")
end
if (dialogres=="igen") then
    fejazon = tostring(ui:findObject('lfejazon'):getText())
    str = 'ellenor_kesobb '..kezelo..' '..fejazon
    t=luafunc.query_assoc(str,false)
    result=t[1]['RESULT']
    resulttext=t[1]['RESULTTEXT']
    if (result=='0') then
       ui:executeCommand('toast','Kiszedés ellenőrzés megszakítása rendben.','')
    else
      ui:executeCommand('toast',resulttext,'')
    end
    ui:executeCommand("close","","")
end
