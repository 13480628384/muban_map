local globals = require 'jass.globals'

--刷兵点数量
local point_count = 30

--刷兵点列表
local point_list = {}
local point_num = 0

--所有野怪数量
all_unit_count = 0

all_unit_map = {}

local is_first_unit = true 

local level = 1

g_game_mode = 0

g_game_min = 0 

--野怪列表
local name_list = {
    '民兵','强盗','兽族投矛兵','血精灵剑士','食人魔',
    '刺蛇','两栖夜行者','骷髅士兵','蛛网怪战士','猛犸象',
    '愤怒丛林漫步者','深海元素','娜迦暴徒','淤泥魔怪','飞蛇',
    '毒性树人','灾祸树人','地狱战舰','憎恶','战争傀儡',
    '红龙','地狱火','成年飞龙','无敌黑暗舞者',
}

--boss 列表
local boss_list = {
    '宙斯','受折磨的灵魂','地精修补匠','地穴编织者','熊战士','嗜血狂魔','深渊领主','山岭巨人','潮汐猎人'
}


--boss 光环列表
local buff_list = {
    'buff-专注光环',
    'buff-吸血光环',
    'buff-命令光环',
    'buff-耐久光环',
    'buff-恢复光环'
}

local skill_list = {
    ['力量'] = {
        '洪流','暗影冲击','大地震','骚灵','凯撒斗技场'
    },
    ['刺杀'] = {
        '暗影冲击','暗能源','季度饥渴'
    },
    ['法师'] = {
        '龙破斩','魔力之枷','火刑','神圣之光'
    }
    
}


local function add_boss_skill(unit,count) 
    local list = skill_list[unit.boss_type or '']
    if not list then 
       return
    end 
    local tbl = {}
    local rand = {}
    for index,name in ipairs(list) do 
        table.insert(tbl,name)
        rand[name] = math.random(#list)
    end 
    table.sort(tbl,function (a,b)
        return rand[a] < rand[b]
    end)

    for i=1,count do
        local name = rand[1]
        if name then 
            unit:add_skill(name,'隐藏')
        end 
        table.remove(rand,1)
    end 
end 

--获取刷新数量 
local function get_refresh_count()

    local player_count = get_player_count()
    --如果野怪数量 小于 60个则一次性刷新60个 否则 小于120 则 6*玩家数 大于则3
    if all_unit_count < 60 then 
        return 60 - all_unit_count
    elseif all_unit_count < 120 then 
        return 6 * player_count
    end  
    --否则3*玩家数
    return 3 * player_count
end 

local function get_boss_count()
    local player_count = get_player_count()
    --玩家数量 * 0.5 向上取整
    return math.ceil(player_count * 0.5) 
end 

--获取刷新单位名字 参数 初始级别 
--按照 level 为中界线 5个等级的类型进行随机抽取一个出来
function get_name_and_level(lv)
    local level_base = math.max(lv,1)
    local pow = 0
    local rate = 1
    if lv > 24 then
        while level_base > 24 do
            level_base = level_base - 5
            pow = pow + 1
        end
        rate = 1.30^pow
    end
    return level_base,rate
end

function get_refresh_unit_name(lv)
    local level = lv
    local base_list = {}
    local rate_list = {}
    for i=0,4 do
        local lv_b,attr_rate = get_name_and_level(level+i)
        local name = name_list[lv_b] --or name_list[level+i - 5 ]
        table.insert(base_list,name)
        table.insert(rate_list,attr_rate)
    end 
    local rand = math.random(1,100)

    --概率 百分比
    local rand_list = {30,30,20,10,10}

    local num = 0
    for index,rate in ipairs(rand_list) do 
        num = num + rate 
        if rand <= num then 
            return base_list[index],rate_list[index]
        end 
    end 
end


--搜索离单位最近的一个英雄
local function find_hero(unit)
    local point = unit:get_point()
    local num = 99999
    local ret = nil 
    for i = 1,9 do 
        local player = ac.player(i)
        local hero = player:get_hero()
        if hero and hero:is_alive() then 
            local dis = hero:get_point() * point
            if dis < num then 
                ret = hero 
                num = dis 
            end 
        end 

    end 
    return ret 
end 

function create_creep(point,level)
    level = level or g_game_min
    local name,rate = get_refresh_unit_name(level)
    --print(name,level,rate)
    local unit = ac.player(10):create_unit(name,point,0)
    unit:set('生命上限',unit:get('生命上限')*rate)
    unit:set('魔法上限',unit:get('魔法上限')*rate)
    unit:set('基础攻击',unit:get('基础攻击')*rate)
    return unit
end


--随机抽取一个名字创建boss
function create_random_boss(min)
    local name = boss_list[math.random(#boss_list)]
    local point = point_list[math.random(12)]
    local unit = ac.player(10):create_unit(name,point,0)
    if unit == nil then 
        return 
    end 
   
    unit.is_boss = true 

    if min > 1 or ac.test == true then 

         --随机添加一个光环技能
        unit:add_skill(buff_list[math.random(#buff_list)],'隐藏',{level = 1})
        
        unit.gold = 0 
        unit.exp = 0
        
        local level = math.ceil(min / 4) 
        unit:set_level(level)
       
        local common = ac.table.unit[name].upgrade_common
        for key,value in pairs(common) do 
            unit:set(key,value * level)
        end 
  
        local count = 2
        if level < 3 then 
            count = 1
        end 
        add_boss_skill(unit,count)
    else 
        for skill in unit:each_skill() do 
            skill:remove()
        end 
    end 
    all_unit_map[unit] = true 
    --unit:set_size(3)
    unit.is_reborn_unit = true 
    return unit 
end 


local function initialize()

    
    --初始化刷兵点列表
    for i=0,point_count - 1 do
        --访问jass中的变量  读取预设在地形编辑器上面的 矩形
        -- local variable_name = string.format("gg_rct______________%03d",i)
        -- local rect = globals[variable_name]
        -- if rect then 
        --     --取矩形的中心点坐标
        --     local x = GetRectCenterX(rect)
        --     local y = GetRectCenterY(rect)
    
            
        --     local point = ac.point(x,y)
        --     table.insert(point_list,point)
        -- end 
        local point = ac.point(math.random(-5000,5000),math.random(-5000,5000))
        table.insert(point_list,point)
    end 

    local id = base.string2id('I000')
        
    local unit = ac.player(10):create_unit('民兵',ac.point(0,0),0)
    local item = UnitAddItemByIdSwapped(id,unit.handle)
    jass.RemoveItem(item)
    ac.wait(100,function ()
        unit:kill()
        unit:remove()
        --all_unit_count = all_unit_count - 1
    end)
    
end 

ac.game:event '单位-死亡' (function (_,unit,killer)

    if killer == nil then 
        return 
    end 


    --如果死亡的是野怪的话
    if not all_unit_map[unit] then
        return 
    end 

    --判断游戏时间超过30分钟 且 游戏模式==简单
    if g_game_min >= 30 and g_game_mode == 1 then 
        local count = 0 
        for _,unit in ac.selector()
            : in_rect()
            : is_not(unit)
            : ipairs()
        do 
            if unit:is_type('野怪') then 
                count = count + 1
            end 
        end 

        if count == 0 then 
            ac.game:event_notify('游戏-结束','胜利')
        end 
    end 
    all_unit_count = all_unit_count - 1
    all_unit_map[unit] = nil 

    local player = killer:get_owner()

    player:addGold(unit.gold,unit,true)
    
    if g_game_min > 5 then 
        unit.exp = unit.exp / 2
    end 


    if killer:is_hero() then
        killer:add_exp(unit.exp)
    end

    for i=1,4 do 
        local hero = player:get_hero()
        if hero ~= nil and hero ~= killer then 
            hero:add_exp(unit.exp)
        end 
    end 

    
    if unit.is_boss then 
        for i=1,7 do 
            local hero = ac.player(i):get_hero()
            if hero then 
                hero:set_level(hero:get_level() + 1)
            end 
        end 
    end 
 


    if unit.is_reborn_unit then 
        return 
    end 
    

    --有百分之2的几率 出现高数值怪物
    local rand = math.random(100)
    if rand <= 2 then 
        ac.wait(1000,function ()
            local point = unit:get_point()
            local reborn = ac.player(10):create_unit(unit:get_name(),point,0)

            reborn:setColor(255,0,0)
            reborn:set_size(1.2)

            local effect = point:effect
            {
                model = [[Abilities\Spells\Human\Resurrect\ResurrectTarget.mdl]],
            }
            
            effect:remove()

            reborn:set('生命上限',unit:get('生命上限') * 10)
            reborn:set('攻击',unit:get('攻击') * 5)
            reborn.exp = unit.exp * 5 
            reborn.gold = unit.gold * 5 
            reborn.is_reborn_unit = true

            unit:remove()
        end)
    end 

   
    
end)


ac.game:event '单位-创建' (function(self, unit)

    if not unit:is_type('野怪') and not unit:is_type('领主') then
		return
    end
   
    local name = unit:get_name()
    local data = ac.table.unit[name]
    if unit and data and not unit.is_reborn_unit then 
        local attr = data.attribute
        unit.gold = math.random(data.gold[1],data.gold[2])
        unit.exp = data.exp
        
        --简单模式下 野怪数值下调30%
        if g_game_mode == 1 then 
            ac.wait(100,function ()
                unit:set('生命上限',unit:get'生命上限' * 0.7)
                unit:set('魔法上限',unit:get'魔法上限' or 1000 * 0.7)
                unit:set('魔法',unit:get('魔法上限'))
                unit:set('基础攻击',unit:get'基础攻击' * 0.7)
                unit:set('基础护甲',unit:get'基础护甲' * 0.7)
            end)
        end 
    end 

    if not unit:is_type('野怪') then
		return
    end


    all_unit_count = all_unit_count + 1
    all_unit_map[unit] = true

    --超过180个怪物的时候开始发警告  超过200个怪物即游戏失败
    if all_unit_count > 180 then 
        if not g_create_timer then 
            g_create_timer = ac.loop(5000,function ()
                if all_unit_count > 180 then    
                    ac.player.self:sendMsg("【系统提示】场上怪物即将超出上限，请尽快在中心泉水购买团队BUFF清怪！")
                else 
                    g_create_timer:remove()
                    g_create_timer = nil
                end 
            end)
            g_create_timer:on_timer()
        end 

        if all_unit_count > 200 then 
            if g_game_min > 30 and g_game_mode == 2 then 
                ac.game:event_notify('游戏-结束','结束')
            else 
                ac.game:event_notify('游戏-结束','失败')
            end
        end 
    end
    
    local hero = find_hero(unit)
    if hero then
        unit:issue_order('attack',hero:get_point())
    end 
end)

ac.game:event '玩家-选择单位' (function(self,player,unit)
    if not unit:is_type('野怪') then
		return
    end
    if not unit:is_alive() then 
        return 
    end 
    local item = unit.item 
    if item ~= nil then 
        RemoveItem(item)
        unit.item = nil
    end 


    local skill = unit:find_skill(1,'隐藏')
    local id = base.string2id('I000')
    if skill then 
        if player == ac.player.self then
            japi.EXSetItemDataString(id, 4, skill:get_name())
            japi.EXSetItemDataString(id, 3, skill:get_tip())
            japi.EXSetItemDataString(id, 1, skill:get_art())
        end
        item = UnitAddItemByIdSwapped(id,unit.handle)
    end
   
    unit.item = item
end)

ac.game:event '玩家-取消选择单位' (function(self,player,unit)
    if not unit:is_type('野怪') then
		return
    end
    local item = unit.item 
    if item ~= nil then 
        RemoveItem(item)
        unit.item = nil
    end
end)


ac.game:event '游戏-结束' (function(_,mode)
    local list = get_player_list()
    
    if mode == '胜利' then 
        for index,player in ipairs(list) do 
            CustomVictoryBJ(player.handle, true, true)
        end 
    elseif mode == '失败' then 
        for index,player in ipairs(list) do 
            CustomDefeatBJ(player.handle, '游戏失败')
        end 
    else
        for index,player in ipairs(list) do 
            CustomDefeatBJ(player.handle, '游戏结束')
        end 
    end 
end)



ac.game:event '游戏-补兵' (function (_,level)
    --获取刷新数量
    local count = get_refresh_count()
    local s = {}
    
    for i = 1,count do  

        local point = point_list[ (point_num % point_count) + 1]
        point_num = point_num - 1

        create_creep(point,level)

    end 
    print('分钟数 ' .. g_game_min .. ' 补兵 ' .. count,table.concat(s))
end)

ac.game:event '游戏-开始刷兵' (function ()

    --初始化刷 100个野怪进攻
    local player = ac.player(10)
    local list = {40,40,20}
    point_num = 24
    for level,count in ipairs(list) do 
        for i = 1,count do 
            --按数量平均分到每个点上面
            point_num = point_num - (math.ceil(point_count / count))
            local point = point_list[ (point_num % point_count) + 1 ]
            local name = name_list[level]
            local unit = player:create_unit(name,point,0)
            local data = ac.table.unit[name]
            if unit and data then 
                unit.gold = math.random(data.gold[1],data.gold[2])
                unit.exp = data.exp * 0.75
            end 
        end 
    end 

    local level = 0
    create_random_boss(1)
    ac.timer_ex
    {
        time = 3 * 60,
        title = 'BOSS进攻',
    }
    --每1分钟 为1个大周期
    local timer = ac.loop(60 * 1000,function (timer)

        g_game_min = g_game_min + 1 

        local n = 4
        --分钟数 为 n 的整倍数的时候刷boss
        if g_game_min > 30 then 
            --无尽模式下 n = 2
            n = 2
            if g_game_mode == 1 then 
                timer:remove()
                return 
            end 
        end 


        if g_game_min == 31 and g_game_mode == 2 then 
            ac.player.self:sendMsg("进入无尽模式！！！")
            ac.player.self:sendMsg("进入无尽模式！！！")
            ac.player.self:sendMsg("进入无尽模式！！！")
            ac.player.self:sendMsg("进入无尽模式！！！")
        end 
        


        if (g_game_min > 32 and g_game_min % 2 == 0) then 
            ac.timer_ex
            {
                time = n * 60,
                title = 'BOSS进攻',
                func = function ()
                    create_random_boss(g_game_min)
                end,
            }
        end 
        --非无尽模式下  分钟数 为 4的整倍数 停怪一分钟
        if g_game_min <= 30 and g_game_min % 4 == 0 then 
            if g_game_min > 0 then 
                ac.timer_ex
                {
                    time = 60,
                    title = '距离怪物进攻',
                }
            end
            create_random_boss(g_game_min)
            ac.timer_ex
            {
                time = n * 60,
                title = 'BOSS进攻',
            }
        else 
            level = level + 1
            --每6秒一个小周期 进行补兵
            ac.timer(6 * 1000,10,function ()
                ac.game:event_notify('游戏-补兵',level)
            end):on_timer()
        end 

    end)
    timer:on_timer()


    --每3秒刷新一次攻击目标
    ac.loop(3 * 1000 ,function ()
        for unit in pairs(all_unit_map) do 
            local hero = find_hero(unit)
            if hero then 
                if unit.target_point and unit.target_point * hero:get_point() < 1000 then 
                    unit.target_point = hero:get_point()
                    unit:issue_order('attack',hero:get_point())
                else 
                    unit.target_point = hero:get_point()
                    if unit:get_point() * hero:get_point() < 1000 then 
                        unit:issue_order('attack',hero)
                    else  
                        unit:issue_order('attack',hero:get_point())
                    end 
                end 
            end 
        end 
    end)
end)

ac.game:event '游戏-选择难度' (function (_,mode)
    if mode == 1 then 
        g_game_mode = mode 
        ac.player.self:sendMsg("【系统提示】坚守30分钟并击杀最终BOSS")
    elseif mode == 2 then 
        g_game_mode = mode
        ac.player.self:sendMsg("【系统提示】困难难度通关后可进入无尽模式")
    end 
    local time = 30
    if ac.test == true then
        time = 0
    end
    BJDebugMsg(time .. "秒后开始刷新野怪")
    ac.timer_ex 
    {
        time = time,
        title = "距离怪物进攻",
        func = function ()
            ac.game:event_notify('游戏-开始刷兵')
        end,
    }
end)

ac.game:event '游戏-开始' (function ()
    local player = get_first_player()
    local list = {
        { name = "简单" },
        { name = "困难" },
    }
    ac.player.self:sendMsg("正在选择难度")
    if player then 
        create_dialog(player,"选择难度",list,function (index)
            ac.game:event_notify('游戏-选择难度',index)
        end)
    end 
end)

ac.wait(100,function ()
    initialize()
    --ac.game:event_notify('游戏-开始')

end)