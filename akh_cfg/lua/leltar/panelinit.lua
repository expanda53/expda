--<verzio>20171211</verzio>
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
uzmod=ui:getGlobal("uzmod")
ui:executeCommand("showprogress","Megnyitás...","")
ui:executeCommand("hideobj","pfooter")
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
if (uzmod=='L') then 
  msg = 'Leltár'
else 
  msg = 'Ellenőrzés'
end  
ui:executeCommand('valueto','lmodulstat',msg)
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)
ui:executeCommand("showobj","mibizlistpanel")
str = 'leltar_mibizlist '..kezelo .. ' ' .. uzmod
list=luafunc.query_assoc_to_str(str,false)
luafunc.refreshtable_fromstring('mibizlist_table',list)

tlist=luafunc.strtotable(list)
count = #tlist
if (count==1) then
  azon=tlist[1]['AZON']
  leir=tlist[1]['LEIR']
  stat6=tlist[1]['STAT6']
  result=tlist[1]['RESULT']
  if (result=='0') then
    ui:executeCommand('toast',leir,'')
    ui:executeCommand("close","","")
  else
    ui:executeCommand('startlua','leltar/mibizlist_click.lua', azon .. ' ' .. leir .. ' ' .. stat6)
  end
else   
  ui:executeCommand("showobj","mibizlist_table")
end  
ui:executeCommand("hideprogress","","")

