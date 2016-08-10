require 'model/Luafunc'
local params = {...}
ui = params[1]
cikk = params[2]:gsub(':','')
vkod = params[3]:gsub(':','')
hkod = params[4]:gsub(':','')
aktdrb = params[5]:gsub(':','')
kezelo = params[6]:gsub(':','')
mibiz = 'leltar_' .. kezelo
mehet = true
if (hkod=="") then
  ui:showMessage('Válasszon helykódot!') 
  mehet=false
end
if (mehet and tonumber(aktdrb)<=0) then 
  ui:showMessage('A teljes mennyiség javítva lett!') 
  mehet=false
else
  if mehet then drb = aktdrb - 1 end
end
if (mehet) then
    seltab = ui:findObject('seltablesum')
	selrow = seltab:getSelectionIndex()
	
	filename = luafunc.ini('exportdir') .. '\\'..mibiz..'.txt'
	file = io.open (filename , "r")
	if (file~=nil) then
	  source = file:read("*a")
	  file:close()
	  t = luafunc.strtotable(source)
	else
	  t={}
	end	
	row_found=false
	for i, r in ipairs(t) do
		  if (r['CIKK'] == cikk and r['LEIR']==vkod and r['HKOD']==hkod) then 
			t[i]['DRB']= drb 
			row_found = true
		  end
		  if row_found then break end
	end  
	if (row_found) then
		file = io.open (filename , "w")
		for i, row in ipairs(t) do
		  adrb = row['DRB']
		  if tonumber(adrb)>0 then
		    sor = '[[CIKK=' .. row['CIKK'] .. ']][[CIKKNEV=' .. row['CIKKNEV'] .. ']][[SORSZ=' ..row['SORSZ'].. ']][[DRB=' .. row['DRB'] .. ']][[HKOD=' ..row['HKOD']..']][[LEIR=' ..row['LEIR']..']][[ELOJEL=' ..row['ELOJEL']..']]\n'
		    file:write (sor) 
		  else
		    selrow=nil
		  end
		end    
		file:close()

		
		filenameu = luafunc.ini('exportdir') .. '\\' .. mibiz.. '_update.txt'
		file = io.open (filenameu , "a")
		sor = 'LELTAR_MENTES '.. cikk ..' ' .. vkod .. ' ' .. hkod .. ' + ' .. kezelo .. ' ' .. drb .. '\n'
		file:write (sor) 

		file:close()
	end
	

	ui:executeCommand("refresh","seltablesum","")
	ui:executeCommand("refresh","seltabledetails","")
	if (selrow~=nil) then 
	  seltab:setSelection(selrow) 
	end

	ui:executeCommand('valuetohidden','seldrb',drb)
	ui:executeCommand('setfocus','seltabledetails','')
	
end