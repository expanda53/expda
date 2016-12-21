--<verzio>20161218</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
--[lfejazon] [lcikod] [eean] [ehkod] [ldrb2] [edrb2] [ldrb] .    
azon = params[2]:gsub("\n",""):gsub(':','')
cikk = params[3]:gsub("\n",""):gsub(':','')
ean = params[4]:gsub("\n",""):gsub(':','')
hkod = params[5]:gsub("\n",""):gsub(':','')
eddigki = params[6]:gsub("\n",""):gsub(':','')
aktki = params[7]:gsub("\n",""):gsub(':','')
osszki = params[8]:gsub("\n",""):gsub(':','')
stat = params[9]:gsub("\n",""):gsub(':','')
kezelo = ui:getKezelo()

if (eddigki=='') then
  --eddig kiadott
  eddigki='0'
end
if (aktki=='') then
  --aktualisan kiadott
  aktki='0'
end 
if (osszki=='') then
  --ossz kiadando
  osszki='0'
end
ujki = tonumber(eddigki) + tonumber(aktki)
osszki=tonumber(osszki)
if (ujki<osszki and stat=='.') then
      ui:executeCommand('show','phiany')
elseif (ujki>osszki) then
      ui:executeCommand('TOAST','HIBA! Többet adna ki, mint a kiadandó!')
      ui:executeCommand('valueto','edrb2','')
      ui:executeCommand('setfocus','edrb2','')
else 
      --selejt, hiany felirasnal osszki-ujki>0
      hiany = osszki - ujki
      str = 'kiadas_mentes ' .. azon .. ' ' .. cikk .. ' ' .. ean .. ' ' .. hkod .. ' ' .. ujki .. ' '..hiany.. ' ' .. stat .. ' '.. kezelo
      t=luafunc.query_assoc(str,false)
      result = t[1]['RESULT']
      resulttext = t[1]['RESULTTEXT']
      if (result=='0') then
          ui:executeCommand('TOAST','Mentés rendben.')
          ui:executeCommand('hide','phiany','')
          ui:executeCommand('startlua','kiadas/kovetkezo_click.lua',azon..' '..hkod..' '..cikk..' 1')
      else
          ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
      end
end


