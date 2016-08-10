require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]


row = ui:findObject('pcikkval_table'):getSelectedRow()  
--txt = row:toString()
--ui:executeCommand('uzenet',txt)
t = luafunc.rowtotable(row)

kod= t['kod']
str = 'mantis_item_notes ' .. kod
listmj=luafunc.query_assoc_to_str(str,false)
if (listmj~=nil) then
luafunc.refreshtable_fromstring('megj_table',listmj)

end
--luafunc.log(t['kod'] .. ' ' ..  t['nev'] .. ' ' .. t['csopnev'])




luafunc.isql_exec('insert into log (value) values("'..t['kod'] .. '")')
--ui:executeCommand('tcpuzenet',t['kod'])
t2 = {}
t2 = luafunc.isql_query("select ID,VALUE from LOG order by id", false)
--luafunc.log('1')
 -- for i, r in ipairs(t2) do 
 
    
	--  val = r['value'] 
  --    id = r['id'] 
	 --luafunc.log(id..':'..val)
 -- end

 str = 'mantis_details ' .. t['kod']
list=luafunc.query_assoc(str,false)
for i, r in ipairs(list) do 
      ui:executeCommand('valueto','lmegj', r['description']:gsub('<enter>','\n') )
if ( r['megoldas']~='') then
ui:executeCommand('valueto','lmegold', r['megoldas'] :gsub('<enter>','\n') )
else
ui:executeCommand('hideobj','lmegold')
end
 ui:executeCommand('valueto','lsum', r['summary'] )
  end
 
ui:executeCommand('showobj','pitem')
if (listmj~=nil) then
  ui:executeCommand('showobj','panelmegj')
else
  ui:executeCommand('hideobj','panelmegj')
end
ui:executeCommand('setfo