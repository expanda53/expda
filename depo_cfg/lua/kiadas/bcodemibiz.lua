--<verzio>20171012</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
mibiz = params[2]:gsub("n",""):gsub(':','')

str = 'applog 0 debug bcodemibiz_start_mibiz:'..mibiz
luafunc.query_assoc(str,false)

row = ui:findObject('mibizlist_table'):findRow('MIBIZ',mibiz)
if (row~=nil) then
  t = luafunc.rowtotable(row)
  cegnev= t['CEGNEV']
  mibiz= t['MIBIZ']

  str = 'applog 0 debug bcodemibiz_findrow_ok'
  luafunc.query_assoc(str,false)

  ui:executeCommand('valueto','lmibiz', mibiz)
  ui:executeCommand('valueto','lcegnev', cegnev)
  ui:executeCommand('hideobj','mibizlist_table;btn_mibizvissza','')
  ui:executeCommand('toast',"Bizonylat: " .. mibiz,'')
  ui:executeCommand('valueto','emibiz', "")
  ui:executeCommand('startlua','kiadas/kovetkezo_click.lua', '')
else
  str = 'applog 0 debug bcodemibiz_findrow_notfound'
  luafunc.query_assoc(str,false)
  ui:executeCommand('toast',mibiz .. " bizonylat nem található!",'')
  ui:executeCommand('valueto','emibiz', "")
  ui:executeCommand('setfocus','emibiz', "")
end
