local ui = require 'ui.server.util'
local timer  = require 'ui.client.timer'
local kzt = {}
kzt.event = {
    --理财投资
    set_licai = function(lv)
        if lv > 300 then
            ui.print('理财等级已满')
            return
        end
        local p = ac.player(GetPlayerId(ui.player) + 1)
        p.gold_lv = lv
    end
}
--发送计时器窗口数据
kzt.up_TimerDialog = function (title,time)
    local info = {
        type = 'kzt',
        func_name = 'up_TimerDialog',
        params = {
            [1] = title,
            [2] = time
        }
    }
    ui.send_message(nil,info)
end

kzt.up_jingong_title = function (title)
    local info = {
        type = 'kzt',
        func_name = 'up_jingong_title',
        params = {
            [1] = title,
        }
    }
    ui.send_message(nil,info)
end

local function initialize()

    ui.register_event('kzt',kzt.event)
    --保存到ac表中
    ac.ui.kzt = kzt
end

initialize()
return kzt