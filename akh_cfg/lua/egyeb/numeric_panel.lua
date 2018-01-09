--<verzio>20171211</verzio>
local params = {...}
ui = params[1]
func = params[2]
if (func=='show') then
    ui:executeCommand("valueto","etext",'')
    caption=""
    target_field = params[3] --ebbe a mezobe rakom vissza az eredmenyt
    target_lua = params[4] --ezt a lua scriptet futtatom. Ha nincs akkor - legyen atadva
    ui:setGlobal("targetfield",target_field)
    ui:setGlobal("targetlua",target_lua)
    if (#params>4) then 
      caption = params[5]:gsub('_',' ')
      ui:executeCommand("valueto","lcap",caption)
    else 
      ui:executeCommand("hideobj","lcap",'')
    end
    ui:executeCommand("showobj","pnumeric",'')
    ui:executeCommand("hideobj","panel1",'')
    
end
if (func=='ok') then 
  target_field = ui:getGlobal("targetfield")
  target_lua = ui:getGlobal("targetlua")
  text = tostring(ui:findObject('etext'):getText())
  if (target_field~='-') then
    ui:setGlobal("targetfield",'-')
    ui:executeCommand("valueto",target_field,text)
  end
  if (target_lua~='-') then
    ui:setGlobal("targetlua",'-')
    ui:executeCommand("show","panel1",'')
    ui:executeCommand("hide","pnumeric",'') 
    ui:executeCommand('startlua',target_lua, '')
    
  else
    ui:executeCommand("show","panel1",'')
    ui:executeCommand("hide","pnumeric",'') 
  end
  --func='hide'
end
if (func=='hide') then
    ui:executeCommand("show","panel1",'')
    ui:executeCommand("hide","pnumeric",'') 
    ui:setGlobal("targetfield",'-')
    ui:setGlobal("targetlua",'-')
end
if (func=='keyp') then  
  key = params[3]
  text = tostring(ui:findObject('etext'):getText())
  if (key=="del") then
    if (text~='') then
        text = text:sub(1,text:len()-1)
        ui:executeCommand("valueto","etext",text)
    end
  else
    text = text .. key
    ui:executeCommand("valueto","etext",text)
  end
    
end