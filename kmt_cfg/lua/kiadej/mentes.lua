--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
--[lfejazon] [eean] [ehkod] [edrb2]  
azon = params[2]:gsub("\n",""):gsub(':','')
cikk = params[3]:gsub("\n",""):gsub(':','')
hkod = params[4]:gsub("\n",""):gsub(':','')
aktki = params[5]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
if (aktki=='') then
  --aktualisan kiadott
  aktki='0'
end 
ujki = tonumber(aktki)
      str = 'kiadej_mentes ' .. azon .. ' ' .. cikk .. ' ' .. hkod .. ' ' .. ujki .. ' '.. kezelo
      t=luafunc.query_assoc(str,false)
      result = t[1]['RESULT']
      resulttext = t[1]['RESULTTEXT']
      ujazon = t[1]['PAZON']
      mibiz = t[1]['MIBIZ']
      if (result=='0') then
          ui:executeCommand('valuetohidden','lfejazon',ujazon)
          ui:executeCommand('valueto','lmibiz',mibiz)
          ui:executeCommand('TOAST','Mentés rendben.')
          ui:executeCommand("startlua","kiadej/ujcikk.lua", '')
      else
          ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
      end



