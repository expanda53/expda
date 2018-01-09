--<verzio>20171211</verzio>
require 'hu.expanda.expda/LuaFunc'
local params = {...}
ui = params[1]
kezelo = ui:getKezelo()
row = ui:findObject('atnezo_table'):getSelectedRow()  
t = luafunc.rowtotable(row)
kod= t['KOD']
nev= t['NEV']
ean= t['EAN']
--ui:executeCommand('toast',ean ..' '..kod..' '..nev,'')

prn='! U1 setvar "power.inactivity_timeout" "0"\r\n'
prn = prn .. '! UTILITIES\r\n'
prn=prn .. 'GAP-SENSE\r\n'
prn=prn .. 'SET-TOF 0\r\n'
prn=prn .. 'PRINT\r\n'
prn=prn .. '! 0 200 200 799 1\r\n'
prn=prn .. 'CENTER\r\n'
prn=prn .. 'SETMAG 1 1\r\n'
prn=prn .. 'VBARCODE 128 3 30 98 105 630 '..ean..'\r\n'
--prn=prn .. 'VTEXT 4 0 30 655 '..kod..'\r\n'
prn=prn .. 'SETMAG 1 1\r\n'
prn=prn .. 'VTEXT 4 0 217 705 '..nev..'\r\n'
prn=prn .. 'PRINT\r\n'
luafunc.btwrite(prn)
