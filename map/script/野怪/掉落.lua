

--按照装备品阶 筛选出 lni 装备。
--quality_item={'白' = {'新手剑','新手戒指'},'蓝' = {..}}
local quality_item ={}
for name,data in pairs(ac.table.ItemData) do 
    local color = data.color 
    if color then 
        local list = quality_item[color] or {}
        table.insert(list,name)
        quality_item[color] = list 
    end 
end 


local function item_self_skill(item)
    local timer = ac.wait(100 * 1000,function (timer)
        if item.owner == nil then 
            item:remove()
        end 
    end)
    item._self_skill_timer = timer 
end 


--先列出所有奖励 再按概率抽取
local reward = {
    ['符文'] = function (player,hero,unit,level)
    
        local list = {'力量符文','敏捷符文','智力符文','血质符文','魔力符文','生命符文','魔法符文'}
        
        if level == nil then 
            if g_game_min < 10 then 
                level = 1 
            elseif g_game_min < 20 then 
                level = 2 
            else 
                level = 3
            end 
        end 

        local name = list[math.random(#list)] .. level 

        
        local x,y = unit:get_point():get() 
        local item = hero:add_item(name)
    end,

    ['随机白装'] = function (player,hero,unit)
        local list = quality_item['白']
        if list == nil then 
            print('没有蓝色装备 添加失败')
            return 
        end 
        local name = list[math.random(#list)]
        print('掉落物品：',name)
        local item = ac.item.create_item(name,unit:get_point())
        item_self_skill(item)
    end,
    ['随机蓝装'] = function (player,hero,unit)
        local list = quality_item['蓝']
        if list == nil then 
            print('没有蓝色装备 添加失败')
            return 
        end 
        local name = list[math.random(#list)]
        print('掉落物品：',name)
        local item = ac.item.create_item(name,unit:get_point())
        item_self_skill(item)
    end,


    ['随机金装'] = function (player,hero,unit)
        local list = quality_item['金']
        if list == nil then 
            print('没有橙色装备 添加失败')
            return 
        end 
        local name = list[math.random(#list)]
        local item = ac.item.create_item(name,unit:get_point())
        item_self_skill(item)
    end,

    ['随机红装'] = function (player,hero,unit)
        local list = quality_item['红']
        if list == nil then 
            print('没有紫色装备 添加失败')
            return 
        end 
        local name = list[math.random(#list)]
        local item = ac.item.create_item(name,unit:get_point())
        item_self_skill(item)
    end,

}



local unit_reward = {
    ['进攻怪'] =  {
        -- { rand = 97.5,         name = '无'},
        { rand = 2.5,      name = {
                { rand = 60, name = '随机白装'},
                { rand = 25, name = '随机蓝装'},
                { rand = 10, name = '随机金装'},
                { rand = 5, name = '随机红装'},
            }
        }
    }
   
}


--递归匹配唯一奖励
local function get_reward_name(tbl)
    local rand = math.random(1,10000) / 100
    local num = 0
    for index,info in ipairs(tbl) do 
        num = num + info.rand 
        print("打印装备掉落概率",info.rand)
        if rand <= num then 
            if type(info.name) == 'string' then 
                return info.name 
            elseif type(info.name) == 'table' then 
                return  get_reward_name(info.name)
            end 
            break 
        end 
    end 
end 

--递归匹配多个奖励
local function get_reward_name_list(tbl,list,level)
    local level = level or 0
    local rand = math.random(1,10000) / 100

    local num = 0
    for index,info in ipairs(tbl) do 
        num = num + info.rand 
        if rand <= num then 
            if type(info.name) == 'string' then 
                table.insert(list,info.name)
            elseif type(info.name) == 'table' then 
                get_reward_name_list(info.name,list,level + 1)
            end 
            if level > 0 then 
                break 
            end
        end 
    end 
end


local function hero_kill_unit(player,hero,unit,fall_rate)

    local change_unit_reward = unit_reward['进攻怪']
    
    for index,info in ipairs(change_unit_reward) do 
        change_unit_reward[index].rand = fall_rate
    end    
    local name = get_reward_name(change_unit_reward)
    if name then 
        local func = reward[name]
        if func then 
            print('掉落',name)
            func(player,hero,unit)
        end 
    end 
end 



--如果死亡的是野怪的话
ac.game:event '单位-死亡' (function (_,unit,killer)
    if unit.category ~='进攻怪' then
		return
    end
    local fall_rate = unit.fall_rate *( 1 + killer:get('物品获取率') )
    -- print('装备掉落概率：',fall_rate,unit.fall_rate)
    local player = killer:get_owner()
    hero_kill_unit(player,killer,unit,fall_rate)


end)


ac.game:event '单位-获得物品后' (function (_,unit,item)
    local timer = item._self_skill_timer 
    if timer then 
        timer:remove()
        item._self_skill_timer = nil 
    end 
end)




--[[

--概率计算测试输出
for a = 1 , 5 do 

    local map = {}
    local count = 0
    for i = 0,1600 do 
        
        local name = get_reward_name(unit_reward['进攻怪'])
        if name then 
            local num = map[name] or 0
            num = num + 1
            map[name] = num
        end
       
    end 
    for name,num in pairs(map) do 
        print(name,num)
    end 

    print('------------------------')

    local map = {}
    local count = 0
    for i = 0,1600 do 
        local rand = math.random(100)
        if rand <= 2 then 
            local list = {}
            get_reward_name_list(unit_reward['复生野怪'],list,0)
            for index,name in ipairs(list) do 
                local num = map[name] or 0
                num = num + 1
                map[name] = num 
            end 
            count = count + 1
        end
    end 
    print("数量为",count)
    for name,num in pairs(map) do 
        print(name,num)
    end 

    print("============================")
end 
]]