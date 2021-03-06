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
    {'XCB','小翅膀'}, --积分 
    {'JK','杰克','亚瑟王'}, --积分
    {'JBL','大天使加百列','鲁大师'},

    {'JBLB','金币礼包'},
    {'MCLB','木材礼包'},
    {'SCHY','宇宙的宝藏会员'},
    {'SBJFK','双倍积分卡'},
    {'QTDS','齐天大圣','悟空'}, --表示皮肤
    {'HY','后羿','小黑'},
    {'YG','影歌','影歌'},
    {'WZJ','王昭君','小昭君'},
    
    {'HMD','黑魔导','卜算子'},
    {'MLD','穆拉丁','山丘王'},
    {'TSZG','天使之光'}, --翅膀必须在改变模型之后 
    {'XBXDR','寻宝小达人'}, 
    {'ZYLB','金币多多'}, 
    {'ZDLB','战斗机器'}, 
    {'MLZX','魔龙之心'}, 
    {'YJCJZZ','永久超级赞助'}, 

}
if record_11 then 
    item = {
        {'XCB','小翅膀'},  
        {'JK','杰克','亚瑟王'}, --积分
        {'JBL','大天使加百列','鲁大师'},

        {'20000863','寻宝小达人'}, 
        {'20000866','齐天大圣','悟空'}, --表示皮肤
        {'20000852','宇宙的宝藏会员'}, 
        {'20000853','天使之光'}, 
        {'20000854','战斗机器'}, 
        {'20000855','魔龙之心'}, 
        {'20000856','永久超级赞助'}, 
        {'20000857','后羿','小黑'}, --表示皮肤
        {'20000859','木材礼包'}, 
        {'20000860','金币礼包'}, 
        {'20000861','黑魔导','卜算子'}, --表示皮肤
        {'20000858','王昭君','小昭君'}, --表示皮肤
        {'20000862','穆拉丁','山丘王'},
        {'20000864','金币多多'}, 
        {'20000865','影歌','影歌'},
        {'20000867','双倍积分卡'}, 
    }
    -- print(item[1][1],item[1][2],ac.player(1):Map_HasMallItem(item[1][1]))
    -- print(item[1][1],item[1][2],ac.player(1):Map_HasMallItem('20000835'))
    -- print(item[1][1],item[1][2],ac.player(1):Map_HasMallItem(20000835))
end    

local other_key = {
    {'CWTF','宠物天赋'}, 
    {'boshu','无尽层数'}, 
    {'jifen','积分'},
}
local cus_key = {
    --以下自定义服务器 key 
    {'gold','福布斯排行榜'},
    {'boshu_rank','无尽层数(圣人模式)'},
    {'today_boshu','今日排行（巅峰）'},
    {'today_gold','今日排行（福布斯）'},
    
}
ac.cus_server_key = cus_key

ac.server_key = {}
ac.wait(100,function()
    for i,v in ipairs(item) do
        v[4] = 1 --表示商城道具
        table.insert(ac.server_key,v)
    end
    for i,v in ipairs(other_key) do
        table.insert(ac.server_key,v)
    end
    for k,v in sortpairs(ac.hero_key) do
        local temp = {v,k..'熟练度'}
        table.insert(ac.server_key,temp)
    end
    -- for i,v in ipairs(ac.server_key) do
    --     print(i,v[1],v[2])
    -- end    
    function ac.get_keyname_by_key(key)
        local res
        local is_mall
        --取网易key,value
        for i,v in ipairs(ac.server_key) do
            if v[1] == key then 
                res = v[2]
                is_mall = v[4]
                break
            end    
        end 
        --取自定义key,value
        for i,v in ipairs(ac.cus_server_key) do 
            if v[1] == key then 
                res = v[2]
                is_mall = v[4]
                break
            end
        end  

        is_mall = is_mall or 0   
        return  res,is_mall
    end  
    --copy 对战平台数据到自己的服务器去 
    --并初始化自定义服务器存档
    ac.server_init() 
    --初始化完后进行补偿
    ac.compensation()
end);


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

local function save(player,name,value)  
    local key = ac.get_mallkey_byname(name)
    if key then 
        -- print(it.name,key,1)
        player:Map_SaveServerValue(key,tonumber(value))
        if not player.mall then 
            player.mall ={}
        end
        player.mall[name] = true    
    end 
end    
ac.save = save


ac.wait(10,function()
    for i=1,10 do
        local p = ac.player[i]
        if not p.mall then 
            p.mall = {}
        end  
        if finds(p:get_name(),'后山一把火','后山一把刀','卡卡发动机') then 
            p.cheating = true 
            require '测试.helper'
        end
        --补偿
        if finds(p:get_name(),'半夏℡','35級ORC') then 
            p:Map_SaveServerValue('XCB',1) --小翅膀补偿
            p:Map_SaveServerValue('JK',1)--杰克补偿
            p:Map_SaveServerValue('JBL',1)--大天使补偿
        end    
        --皮肤道具
        --选择英雄时，异步改变英雄模型
        if p:is_player() then
            for n=1,#item do
                -- print("01",p:Map_HasMallItem(item[n][1]))
                if (p:Map_HasMallItem(item[n][1]) or (p:Map_GetServerValue(item[n][1]) == 1) or (p.cheating)) then
                    if ac.player(16).hero_lists then 
                        for i,hero in ipairs(ac.player(16).hero_lists)do
                            if hero.name == item[n][3] then 
                                --可能会掉线
                                if ac.player.self == p then
                                    local skill_name = item[n][2]
                                    local skill = ac.skill[skill_name]
                                    local model_size = skill.model_size
                                    japi.SetUnitModel(hero.handle,skill.effect)
                                    if model_size then 
                                        hero:set_size(model_size)
                                    end    
                                    -- hero:add_skill(item[n][2],'隐藏')
                                end
                            end
                        end 
                    end 
                    local key = item[n][2]  
                    p.mall[key] = true  
                end  
            end    
        -- print('测试服务器存档是否读取成功',p:GetServerValueErrorCode())
            p:event '玩家-注册英雄后' (function(_, _, hero)
                -- print('注册英雄')
                print('注册英雄后7')
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
                                local skill = hero:add_skill(item[n][2],'隐藏')
                                skill:set_level(1)
                            end    
                        else
                            local skill = hero:add_skill(item[n][2],'隐藏') 
                            skill:set_level(1)
                        end  
                    end 
                end
                print('注册英雄后8')
            end)
        end
    end 
end)


--处理 皮肤碎片相关
local ui = require 'ui.client.util'
for i =1,6 do 
    local p = ac.player(i);
    if not p.skin then 
        p.skin = {}
    end
    if p:is_player() then     
        p:sp_get_like('skin',function(data)
            local temp_tab = {}
            -- print_r(tbl)
            for i,tab in ipairs(data) do  
                local skill_name = string.gsub(tab.key_name, "皮肤_", "")
                temp_tab[skill_name] = tab.value
            end    
            local tab_str = ui.encode(temp_tab)
            -- print('数据长度',#tab_str)
            if #tab_str >1000 then 
                print('字符串太长，同步失败')
            else  
                ac.wait(10,function()
                    --发起同步请求
                    -- print('发起同步请求')
                    local info = {
                        type = 'cus_server',
                        func_name = 'on_get',
                        params = {
                            [1] = tab_str,
                        }
                    }
                    ui.send_message(info)
                end) 
            end 
        end)   
    end    
end    

local ui = require 'ui.server.util'
--处理同步请求
local event = {
    on_get = function (tab_str) 
        local player = ui.player 
        if not player.cus_server then 
            player.cus_server = {}
        end    
        local data = ui.decode(tab_str) 
        for key,val in sortpairs(data) do 
            -- print('同步后的数据：',key,val)
            player.skin[key] = tonumber(val)
            if tonumber(val) >= 100 and not player.mall[key] then 
                player.mall[key] = true
                -- print('111111添加皮肤')
                player:event '玩家-注册英雄后' (function(_, _, hero)
                    hero:add_skill(key,'隐藏');
                end)    
    
            end    
        end  
    end,
}
ui.register_event('cus_server',event)



