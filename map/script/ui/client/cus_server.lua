local ui            = require 'ui.client.util'
local game          = require 'ui.base.game'
local json = require 'util.json'
local player = require 'ac.player'

local config = {
    map_name = '天空的宝藏',
    url = 'www.91mtp.com/api/maptest' , --类似官方对战平台的服务器存档
    url2 = 'www.91mtp.com/api/mapdb' --统一存储过程入口
}

local cundang = {}
cundang.tongbu = function(p,value)
    local info = {
        type = 'cundang',
        func_name = 'tongbu',
        params = {
            [1] = p:get(),
            [2] = value,
        }
    }
    ui.send_message(info)
end

function player.__index:GetServerValue(KEY,f)
    local player_name = self:get_name()
    local map_name = config.map_name
    local url = config.url

    local post = 'get=' .. json.encode({
        map_name = map_name,
        player_name = player_name,
        key = KEY,
    })

    post_message(url,post,function (retval)  
        local value = string.find(retval, 'error_code')
        if value == nil then
            local tbl = json.decode(retval)
            for k, v in ipairs(tbl) do
                for key, value in pairs(v) do
                    f(value)
                end
            end
        end
        -- self:event_notify('玩家-读取数据', tbl) 没用
    end)
end
--保存到 map_test 
function player.__index:SetServerValue(key,value,f)
    local player_name = self:get_name()
    local map_name = config.map_name
    local url = config.url2
    local key_name,is_mall = ac.get_keyname_by_key(key)
    local value = tostring(value)

    local post = 'exec=' .. json.encode({
        sp_name = 'sp_save_map_test',
        para1 = map_name,
        para2 = player_name,
        para3 = key,
        para4 = key_name,
        para5 = value,
        para6 = is_mall,
    })
    local f = f or function (retval)  end
    -- print(url,post)
    post_message(url,post,f)

end

--copy servervalue 到 map_test 
function player.__index:CopyServerValue(key,f)
    local player_name = self:get_name()
    local map_name = config.map_name
    local url = config.url2
    local value,key_name,is_mall = ac.get_server(self,key)
    -- print(map_name,player_name,key,key_name,is_mall,value)
    local post = 'exec=' .. json.encode({
        sp_name = 'sp_save_map_test',
        para1 = map_name,
        para2 = player_name,
        para3 = key,
        para4 = key_name,
        para5 = value,
        para6 = is_mall,
    })
    -- print(url,post)
    local f = f or function (retval)  end
    post_message(url,post,f)
end

function player.__index:CopyAllServerValue()
    for i,v in ipairs(ac.server_key) do 
        local key = v[1]
        self:CopyServerValue(key)
    end    
end    

cundang.event = {
    yibu = function()
        local yibu_sjs = 0
        client.loop(2000,function()
            yibu_sjs = yibu_sjs + 1

            local info = {
                type = 'cundang',
                func_name = 'yanzheng',
                params = {
                    [1] = 1,
                }
            }
            ui.send_message(info)
        end)
    end
}

ui.register_event('cundang',cundang.event)
game.register_event(cundang)


local function init()
    for i=1,6 do 
        local p = ac.player(i)
        if p:is_player() then 
            p:CopyAllServerValue()
        end    
    end    
end  
ac.server_init = init
--执行顺序问题。
-- ac.wait(600,function()
--     init()
-- end)

--[[
思路：
1.进游戏时，往 map_player 插入玩家数据 ，存在更新时间，不存在插入
2.copy 一份服务器存档的数据到 map_test 里面，一样时存在即更新，不存在插入
3.copy 一份商城道具也再服务器存档里面，
4.读取业务端数据 例如排行榜，显示。
5.保存业务端数据到服务器。

]]
--测试

local p = ac.player(1)
-- p:CopyServerValue('XCB')

-- p:SetServerValue('boshu',321,function (retval)
--     local tbl = json.decode(retval)
--     print('保存')
-- end)

-- p:GetServerValue('boshu',function (value)  
--    print(value)
-- end)






