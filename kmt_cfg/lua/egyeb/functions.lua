--<verzio>20161223</verzio>
require 'hu.expanda.expda/LuaFunc'
    
function alert(ui,msg)    
  ui:executeCommand('playaudio','alert.mp3','')
  if (msg~="") then
    ui:executeCommand('toast',msg,'')
  end
end
