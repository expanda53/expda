--<verzio>20171211</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
ui:executeCommand("showprogress","Megnyitás...","")
ui:executeCommand("hideobj","pfooter")
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Leltár')
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)
ui:executeCommand("showobj","mibizlistpanel")
str = 'leltar_mibizlist '..kezelo
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('mibizlist_table',list)

tlist=luafunc.strtotable(list)
count = #tlist
if (count==1) then
  azon=tlist[1]['AZON']
  leir=tlist[1]['LEIR']
  result=tlist[1]['RESULT']
  if (result=='0') then
    ui:executeCommand('toast',leir,'')
    ui:executeCommand("close","","")
  else
    ui:executeCommand('startlua','leltar/mibizlist_click.lua', azon .. ' ' .. leir)
  end
else   
  ui:executeCommand("showobj","mibizlist_table")
end  
ui:executeCommand("hideprogress","","")

