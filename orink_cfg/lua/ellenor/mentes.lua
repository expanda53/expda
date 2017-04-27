--<verzio>20170405</verzio>
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
  if (tonumber(aktki)==0 and tonumber(osszki)>0) then
      ui:executeCommand('TOAST','HIBA! Nem adott meg ellenőrizendő mennyiséget!')
      ui:executeCommand('valueto','edrb2','')
      ui:executeCommand('setfocus','edrb2','')
  else
      str = 'ellenor_mentes ' .. azon .. ' ' .. cikk .. ' ' .. ean .. ' '  .. aktki .. ' '.. kezelo .. ' ' .. kulsoraktar
      t=luafunc.query_assoc(str,false)
      result = t[1]['RESULT']
      resulttext = t[1]['RESULTTEXT']
      if (result=='0') then
        if (ujki==0) then
          str = 'Törlés rendben.'
        else
            bevmod = tostring(ui:findObject('lbevmod'):getText())
            if (bevmod=='auto') then
              str = "Mentés rendben. Ellenőrizve: " .. osszki .. "/" .. ujki
            else
              str = "Mentés rendben."
            end
        end
        ui:executeCommand('TOAST',str)
        ui:executeCommand("startlua","ellenor/ujean.lua",'')
      else
          ui:executeCommand('uzenet',resulttext,"egyeb/setfocus.lua eean")
      end
  end
end


