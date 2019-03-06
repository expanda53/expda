--<verzio>20180911</verzio>
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
    ui:showDialog("Biztos megszakítja a kiadást? ".. mibiz,"kiadkesz/kiadaskesobb.lua igen ","kiadkesz/kiadaskesobb.lua nem")
end
if (dialogres=="igen") then
    ui:executeCommand("close","","")
end
