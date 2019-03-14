--[[

    只有客户端 没有服务端的界面
    玩家控制台底部，友军面板，敌人面板

]]
local ui            = require 'ui.client.util'
local timer         = require 'ui.client.timer'
local game          = require 'ui.base.game'
local console = {}

local types = {
    ['小地图按钮']  = 'DzFrameGetMinimapButton',
    ['小地图']      = 'DzFrameGetMinimap',
    ['头像模型']    = 'DzFrameGetPortrait',
    ['技能按钮']    = 'DzFrameGetCommandBarButton',
    ['头像图标']    = 'DzFrameGetHeroBarButton',
    ['血条']        = 'DzFrameGetHeroHPBar',
    ['蓝条']        = 'DzFrameGetHeroManaBar',
    ['提示框']      = 'DzFrameGetTooltip',
    ['菜单按钮']    = 'DzFrameGetUpperButtonBarButton',
    ['聊天消息']    = 'DzFrameGetChatMessage',
    ['单位消息']    = 'DzFrameGetUnitMessage',
    ['顶上消息']    = 'DzFrameGetTopMessage',
}
local controls = {}

console.get = function (name,...)
    local args = {...}
    local row = args[1]
    local column = args[2]
    local func_name = types[name]
    if func_name == nil then 
        return 
    end 
    local key = string.format('%s%s%s',name,tostring(row or ''),tostring(column or ''))
    local instance = controls[key]
    if instance == nil then 
        local control_id = dzapi[func_name](row,column)
        if control_id == nil or control_id == 0 then 
            return 
        end 
        instance = extends(button_class,{
            id = control_id,
            w = 0,
            h = 0,
        })
        if name == '血条' or name == '蓝条' then 
            instance.set_position = function (self,x,y)
                self.x = x
                self.y = y
                x =  (x + self.w / 2) / 1920 * 0.8
                y = (1080 - y) / 1080 * 0.6
                dzapi.DzFrameSetPoint(self.id,1,game_ui,6,x,y)
            end
        elseif name == '头像模型' then 
            instance.set_position = function (self,x,y)
                self.x = x
                self.y = y
                x =  x / 1920 * 0.8
                y = (1080 - y - self.h) / 1080 * 0.6
                dzapi.DzFrameSetPoint(self.id,6,game_ui,6,x,y)
            end
        elseif name == '小地图' then 
            instance.set_position = function (self,x,y)
                self.x = x
                self.y = y
                local ax =  x / 1920 * 0.8
                local ay = (1080 - y - self.h) / 1080 * 0.6
                local bx = (x + self.w) / 1920 * 0.8
                local by = (1080 - y) / 1080 * 0.6
                dzapi.DzFrameSetPoint(self.id,6,game_ui,6,ax,ay)
                dzapi.DzFrameSetPoint(self.id,2,game_ui,6,bx,by)
            end
        elseif name == '技能按钮' then 
            instance.w = 91
            instance.h = 69
            instance.row = row 
            instance.column = column
        elseif name == '提示框' then 
            instance.set_position = function (self,x,y)
                self.x = x
                self.y = y
                x =  (x - self.w * 1.5) / 1920 * 0.8
                y =  -y / 1080 * 0.6
                dzapi.DzFrameSetPoint(self.id,8,game_ui,1,x,y)
            end

        elseif name == '聊天消息' then
            instance.set_position = function (self,x,y)
                self.x = x
                self.y = y
                x =  x / 1920 * 0.8
                y =  -y / 1080 * 0.6
                dzapi.DzFrameSetPoint(self.id,0,game_ui,0,x,y)
            end
        elseif name == '单位消息' then
            instance.set_position = function (self,x,y)
                self.x = x
                self.y = y
                x =  x / 1920 * 0.8
                y =  -y / 1080 * 0.6
                dzapi.DzFrameSetPoint(self.id,0,game_ui,0,x,y)
            end
        end 
        controls[key] = instance
    end 
    return instance
end 



--=================================================================================================================
--                                      控制台
--=================================================================================================================
local kzt = {}
kzt.event = {
     --进攻提示
     up_jingong_title = function(title)
        kzt.jingong.title:set_text(title)
        if not kzt.jingong.old_x then 
            kzt.jingong.old_x,kzt.jingong.old_y = kzt.jingong:get_position()
        end
        kzt.jingong:set_position(kzt.jingong.old_x,kzt.jingong.old_y)
        kzt.jingong:show()
        --创建一个计时器
        local time = timer.create(self,3,false,function (timer,button)
            -- local x = kzt.jingong.x
            -- local y = kzt.jingong.y

            kzt.jingong:set_position(kzt.jingong.x,50)
            -- if y<=50 then 
            --     timer:stop()
            -- end    
            
            -- kzt.jingong:hide()
            timer:stop()
        end)
    end,
    --更新计时器窗口文字
    --标题
    --时间 秒级
    up_TimerDialog = function(title,time)
        local h = math.floor(time / 3600)
        local m = math.floor((time % 3600) / 60)
        local s = math.floor((time % 3600) % 60)
        h = h..''
        m = m..''
        s = s..''
        --当显示数字为个位数时，前位用0补上
        if string.len(h) == 1 then
            h = "0"..h
        end

        if string.len(m) == 1 then
            m = "0"..m
        end

        if string.len(s) == 1 then
            s = "0"..s
        end

        time = h..':'..m..':'..s

        kzt.top_panel.djs:set_text(title..time)
    end,
}

--============================================================
--                          计时器窗口
--============================================================
local TimerDialog = {}
TimerDialog = extends(panel_class,{
    create = function ()
        local panel = panel_class.create('image\\控制台\\container_COLOR_BIG.tga',1670,50,220,40)
        local title = panel:add_text('即将开始',10,10,60,20,11,3)
        local time = panel:add_text('',80,15,130,12,9,5)
        panel.title = title
        panel.time = time
        --创建一个可拖动的标题按钮
        panel.title_button = panel:add_title_button('','',0,0,panel.w,panel.h,25)
        return panel
    end
})

--============================================================
--                          进攻提示
--============================================================
local jingong = {}
jingong = extends(panel_class,{
    create = function ()
        local panel = panel_class.create('image\\控制台\\jingong.tga',(1920-700)/2,300,700,250)
        local title = panel:add_text('',(panel.w-260)/2,(panel.h-40)/2-30,260,40,15,4)
        panel.title = title
        return panel
    end
})

local shibai = {}
shibai = extends(panel_class,{
    create = function()
        local panel = panel_class.create('image\\控制台\\youxishibai.tga',760,380,400,319)
        panel:hide()
        return panel
    end
})


--系统提示文字 只给全局玩家用
local system_text = {}
system_text = extends(panel_class,{
    create = function()
        local panel = panel_class.create('',0,850,1920,15)
        extends(system_text,panel)
        panel.str_text = panel:add_text('',0,0,1920,15,12,4)
        return panel
    end,
})

--系统文字  - 大
local window_text = {}
window_text = extends(panel_class,{
    create = function()
        local panel = panel_class.create('',0,750,1920,40)
        extends(window_text,panel)
        panel.str_text = panel:add_text('',0,0,1920,40,20,4)
        return panel
    end,
})

--兽潮黑屏
local heiping = {}
heiping = extends(panel_class,{
    create = function()
        local panel = panel_class.create('image\\控制台\\heiping.tga',0,0,1920,1080)
        extends(heiping,panel)
        panel:set_alpha(0.8)
        return panel
    end,
})
c_ui.heiping = heiping.create()
c_ui.heiping:hide()


c_ui.window_text = window_text.create()
function c_ui.set_windows_text(str,time)
    if c_ui.windows_time then
        c_ui.windows_time:remove()
        c_ui.windows_time = nil
    end
    if not time then
        time = 10
    end

    c_ui.window_text.str_text:set_text(str)
    c_ui.windows_time = client.wait(time * 1000,function()
        c_ui.window_text.str_text:set_text('')
        c_ui.windows_time:remove()
        c_ui.windows_time = nil
    end)


end





--系统提示文字
kzt.set_system_text = function(str,time)
    kzt.system_text.str_text:set_alpha(1)
    kzt.system_text.str_text:set_text(str)
    --10秒后开始淡化
    if not time then
        time = 10
    end
    client.wait(1000*time,function()
        client.timer(100,10,function(t)
            kzt.system_text.str_text:set_alpha(t.count/10)
        end)
    end)
end



local function initialize()
    
    --计时器窗口
    --kzt.TimerDialog = TimerDialog.create()

    --进攻提示
    kzt.jingong = jingong.create()
    kzt.jingong:hide()


    --游戏失败
    kzt.shibai = shibai.create()


    ui.register_event('kzt',kzt.event)
    game.register_event(kzt)
end
c_ui.kzt = kzt
initialize()

return kzt
