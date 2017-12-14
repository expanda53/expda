--<verzio>20171012</verzio>
local params = {...}
ui = params[1]
ui:executeCommand("hideobj","pfooter")
kezelo = ui:getKezelo()
ui:executeCommand('valueto','lkezelostat','Kezelő: '..kezelo)
ui:executeCommand('valueto','lmodulstat','Kiadás')
version = ui:getGlobal("appversion")
ui:executeCommand('valueto',"lverzio",'exPDA v' .. version)
startbiz = ui:getGlobal("startbiz")
if (startbiz~="-") then
      mibiz=startbiz
      str = 'applog 0 debug bcodemibiz_findrow_ok'
      luafunc.query_assoc(str,false)
      startceg = ui:getGlobal("startceg")
      ui:executeCommand('valueto','lmibiz', mibiz)
      ui:executeCommand('valueto','lcegnev', startceg)
      ui:executeCommand('hideobj','mibizlist_table;btn_mibizvissza','')
      ui:executeCommand('showobj','pfooter;eean;button_review;button_kovetkezo','')
      ui:executeCommand('valueto','emibiz', "")
      ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', '')
else 
    str = 'kiadas_mibizlist '..kezelo
    list=luafunc.query_assoc_to_str(str,false)
    luafunc.refreshtable_fromstring('mibizlist_table',list)
    ui:executeCommand("showobj","mibizlist_table")
    ui:executeCommand('aktbcodeobj','bcodemibiz','')
    ui:executeCommand('setfocus','emibiz','')
end    
