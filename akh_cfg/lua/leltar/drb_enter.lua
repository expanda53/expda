--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui=params[1]
vegell=ui:getGlobal("vegell")
rdrb=tostring(ui:findObject('cap_rdrb'):getText()):gsub("n",""):gsub(':','')
caption='Mennyiség_(már számolt:'.. rdrb ..')'

if (vegell=='V') then
    capell = tostring(ui:findObject('cap_elldrb'):getText()):gsub("n","")
    caption = caption .. ' ' ..capell
    caption = caption:gsub(' ','_')
end
ui:executeCommand('startlua','egyeb/numeric_panel.lua', "show edrb leltar/mentes.lua " .. caption)

