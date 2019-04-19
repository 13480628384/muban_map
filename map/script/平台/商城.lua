-- local Base64 = require 'ac.Base64'
local japi = require 'jass.japi'

--开启FPS
-- ac.wait(0,function() 
--     japi.ShowFpsText(true)
--     ac.loop(1000,function()
--         if ac.player.self then
--             c_ui.kzt.top_panel.fps:set_text('FPS:'..math.floor(japi.GetFps()))
--         end
--     end)
-- end);

--读取玩家的商城道具
local item = {
    {'JBLB','金币礼包'},
    {'MCLB','木材礼包'},
    {'SCHY','生存会员'},
    {'TSZG','天使之光'},
    {'SBJFK','双倍积分卡'},
    {'QTDS','齐天大圣','悟空'}, --表示皮肤
    {'HY','后羿','小黑'},
    {'YG','影歌','影歌'},
    {'WZJ','王昭君','小昭君'},

    {'XCB','小翅膀'}, --积分 
    {'JK','杰克','亚瑟王'}, --积分

}
local function get_mallkey_byname(name)
    local res
    for i=1,#item do
        if item[i][2] == name then 
            res = item[i][1]
            break
        end    
    end
    return res
end 
ac.mall =   item 
--根据商城物品名取得对应的key
ac.get_mallkey_byname = get_mallkey_byname
ac.wait(10,function()
    for i=1,10 do
        local p = ac.player[i]
        if not p.mall then 
            p.mall = {}
        end  
        --皮肤道具
        --选择英雄时，异步改变英雄模型
        for n=1,#item do
            if p:Map_HasMallItem(item[n][1]) or (p:Map_GetServerValue(item[n][1]) == '1') then
                if ac.player(16).hero_lists then 
                    for i,hero in ipairs(ac.player(16).hero_lists)do
                        if hero.name == item[n][3] then 
                            --可能会掉线
                            if ac.player.self == p then
                                hero:add_skill(item[n][2],'隐藏')
                            end
                        end
                    end 
                end 
                local key = item[n][2]  
                p.mall[key] = true  
            end  
        end    
        -- print('测试服务器存档是否读取成功',p:GetServerValueErrorCode())
        if p:is_player() then
            p:event '玩家-注册英雄后' (function(_, _, hero)
                -- print('注册英雄')
                for n=1,#item do
                    --商城 或是 存档 有相关的key则进行处理
                    local key = item[n][2]  
                    -- print(key,p.mall[key])
                    if p.mall[key] then
                    -- if p:Map_HasMallItem(item[n][1]) or (p:Map_GetServerValue(item[n][1]) == '1') then
                        --物品形式
                        if item[n][2] == '金币礼包' or item[n][2] == '木材礼包' then
                            hero:add_item(item[n][2],true) 
                        end
                        --直接生效（技能）
                        if item[n][3]  then 
                            --设置英雄模型(皮肤)
                            if hero.name == item[n][3] then 
                                hero:add_skill(item[n][2],'隐藏')
                            end    
                        else
                            hero:add_skill(item[n][2],'隐藏') 
                        end  
                    end 
                end
            end)
        end
    end 
end)

