--<verzio>20170329</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
--[lfejazon] [lcikod] [eean] [edrb2] [ldrb2] [ldrb]
azon = params[2]:gsub("\n",""):gsub(':','')
cikk = params[3]:gsub("\n",""):gsub(':','')
ean = params[4]:gsub("\n",""):gsub(':','')
aktki = params[5]:gsub("\n",""):gsub(':','')
eddigki = params[6]:gsub("\n",""):gsub(':','')
osszki = params[7]:gsub("\n",""):gsub(':','')

kezelo = ui:getKezelo()
kulsoraktar = ui:getGlobal("kulsoraktar")
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
if (ujki>osszki) then
      ui:executeCommand('TOAST','HIBA! Több az ellenőrzött, mint az előírt!')
      ui:executeCommand('valueto','edrb2','')
      ui:executeCommand('setfocus','edrb2','')
else 
      str = 'ellenor_mentes ' .. azon .. ' ' .. cikk .. ' ' .. ean .. ' '  .. aktki .. ' '.. kezelo .. ' ' .. kulsoraktar
      t=luafunc.query_assoc(str,false)
      result = t[1]['RESULT']
      resulttext = t[1]['RESULTTEXT']
      if (result=='0') then
          ui:executeCommand('TOAST','Mentés rendben.')
          ui:executeCommand('valueto','ldrb2',ujki)
          ui:executeCommand('valueto','edrb2','')
      else
          ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
      end
end


