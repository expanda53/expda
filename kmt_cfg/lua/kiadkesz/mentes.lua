--<verzio>20180911</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
--[lfejazon] [lcikod] [eean] [ehkod] [ldrb2] [edrb2] [ldrb] .    
azon = params[2]:gsub("\n",""):gsub(':','')
cikk = params[3]:gsub("\n",""):gsub(':','')
ean = params[4]:gsub("\n",""):gsub(':','')
hkod = params[5]:gsub("\n",""):gsub(':','')
aktki = params[6]:gsub("\n",""):gsub(':','')
osszki = params[7]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()
if (aktki=='') then
  --aktualisan kiadott
  aktki='0'
end 
if (osszki=='') then
  --ossz kiadando
  osszki='0'
end
ujki = tonumber(aktki)
osszki=tonumber(osszki)
if (ujki>osszki) then
      ui:executeCommand('TOAST','HIBA! Többet adna ki, mint a kiadandó!')
      ui:executeCommand('valueto','edrb2','')
      ui:executeCommand('setfocus','edrb2','')
else 
      str = 'kiadkesz_mentes ' .. azon .. ' ' .. cikk .. ' ' .. ean .. ' ' .. hkod .. ' ' .. ujki .. ' '.. kezelo
      t=luafunc.query_assoc(str,false)
      result = t[1]['RESULT']
      resulttext = t[1]['RESULTTEXT']
      if (result=='0') then
          ui:executeCommand('TOAST','Mentés rendben.')
          if (osszki~=0) then 
            ui:executeCommand('startlua','kiadkesz/kovetkezo_click.lua',azon..' '..hkod..' '..cikk..' 1')
          end
      else
          ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
      end
end


