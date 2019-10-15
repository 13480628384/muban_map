local ui = require 'ui.server.util'
local trg = CreateTrigger()
local japi = require 'jass.japi'
register_japi[[
    native DzTriggerRegisterSyncData        takes trigger trig, string prefix, boolean server returns nothing
    native DzSyncData                       takes string prefix, string data returns nothing
    native DzGetTriggerSyncData             takes nothing returns string
    native DzGetTriggerSyncPlayer           takes nothing returns player
]]  

--注册同步事件
japi.RegisterMessageEvent(trg)
TriggerAddAction(trg,function ()
    local message = japi.GetTriggerMessage()
    local player = japi.GetMessagePlayer()
    print(message:len(),message,player)
  
    ui.on_custom_ui_event(player,message)
end)

--注册同步事件
-- japi.DzTriggerRegisterSyncData(trg,"ui",false)
-- TriggerAddAction(trg,function ()
--     local message = japi.DzGetTriggerSyncData()
--     local player = japi.DzGetTriggerSyncPlayer()
--     print(message:len(),message,player)
    -- ui.on_custom_ui_event(player,message)
    -- ui.on_custom_ui_event(ac.player(GetPlayerId(player) + 1),message)
-- end)


