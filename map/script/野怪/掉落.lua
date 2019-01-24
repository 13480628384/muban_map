
local equipments = {}
local has_equipment = false 

for name,data in pairs(ac.table.item) do 
    local color = data.color 
    if data.item_type == '装备' and color then 
        if color then 
            local list = equipments[color] or {}
            equipments[color] = list 

            table.insert(list,name)
        end 
    end 
end 

for color,list in pairs(equipments) do 
    table.sort(list,function (a,b) return a < b end)
end 

local function is_mul_kill(unit)
    return false 
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

    ['命运宝箱'] = function (player,hero,unit)
        local name = '命运宝箱'
        local x,y = unit:get_point():get() 
        local item = hero:add_item(name)
        item_self_skill(item)
    end,

    ['随机蓝装'] = function (player,hero,unit)
        local list = equipments['蓝']
        if list == nil then 
            print('没有蓝色装备 添加失败')
            return 
        end 
        local name = list[math.random(#list)]
        local x,y = unit:get_point():get() 
        local item = hero:add_item(name)
        item_self_skill(item)
    end,

    ['随机紫装'] = function (player,hero,unit)
        local list = equipments['紫']
        if list == nil then 
            print('没有紫色装备 添加失败')
            return 
        end 
        local name = list[math.random(#list)]
        local x,y = unit:get_point():get() 
        local item = ac.item.create(name,x,y)
        item_self_skill(item)
    end,

    ['随机橙装'] = function (player,hero,unit)
        local list = equipments['橙']
        if list == nil then 
            print('没有橙色装备 添加失败')
            return 
        end 
        if has_equipment then 
            print('只能掉落一件橙装')
            return 
        end 
        local name = list[math.random(#list)]
        local x,y = unit:get_point():get() 
        local item = ac.item.create(name,x,y)
        item_self_skill(item)
        has_equipment = true 
    end,

    ['普通技能卡'] = function (player,hero,unit)
        if g_game_min > 10 then 
            return 
        end 
        local name = '普通技能卡'
        local x,y = unit:get_point():get() 
        local item = hero:add_item(name)
        item_self_skill(item)
    end,

    ['高级技能卡'] = function (player,hero,unit)
        local name = '高级技能卡'
        local x,y = unit:get_point():get() 
        local item = hero:add_item(name)
        item_self_skill(item)
    end,

}



local unit_reward = {
    ['普通野怪'] =  {
        { rand = 20,         name = '符文'},
        { rand = 80,      name = {
                { rand = 30,    name = '命运宝箱'},
                { rand = 0.02, name = '随机紫装'},
                { rand = 0.1, name = '随机蓝装'},
                { rand = 0.01, name = '随机橙装'},
                { rand = 0.5,    name = '普通技能卡'},
                { rand = 0.2,    name = '高级技能卡'},
            }
        }
    },

    ['复生野怪'] =  {
        { rand = 35,        name = '符文'},
        { rand = 6,         name = {
                { rand = 5, name = '随机蓝装'},
                { rand = 1,  name = '随机紫装'},
                { rand = 0.5,  name = '随机橙装'},
            },
        },
        { rand = 10,        name = {
                { rand = 50,    name = '普通技能卡'},
                { rand = 20,    name = '高级技能卡'},
            },
        },
        { rand = 80,        name = '命运宝箱'},

    },
   
}


--递归匹配唯一奖励
local function get_reward_name(tbl)
    local rand = math.random(1,10000) / 100
    local num = 0
    for index,info in ipairs(tbl) do 
        num = num + info.rand 
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


local function hero_kill_unit(player,hero,unit)

    --判断是否是复生野怪 取各自的 随机模式
    if unit.is_reborn_unit then 
        local list = {}
        get_reward_name_list(unit_reward['复生野怪'],list)
        for index,name in ipairs(list) do 
            local func = reward[name]
            if func then 
                --print('掉落',name)
                if name == '符文' then 
                    --复生野怪掉落的符文必定是3级符文
                    func(player,hero,unit,3)
                else 
                    func(player,hero,unit)
                end 
                
            end 
        end 
    else 
        local name = get_reward_name(unit_reward['普通野怪'])
        if name then 
            local func = reward[name]
            if func then 
                print('掉落',name)
                func(player,hero,unit)
            end 
        end 
    end 
end 



--如果死亡的是野怪的话
ac.game:event '单位-死亡' (function (_,unit,killer)
    if not unit:is_type('野怪') then
		return
    end

    local player = killer:get_owner()
    hero_kill_unit(player,killer,unit)

    

end)


ac.game:event '单位-获得物品' (function (_,unit,item)
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
        
        local name = get_reward_name(unit_reward['普通野怪'])
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