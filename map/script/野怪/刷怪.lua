-- 每回合刷 25 人口的怪物
-- 喽喽占 1个人口，小怪占 2个人口，头目占4人口，boss占20人口
-- 小怪、头目、boss属性是喽喽的多倍
-- 每个回合刷的 同怪物类型 的怪物都是同样。
--boss 光环列表
local buff_list = {
    'buff-专注光环',
    'buff-吸血光环',
    'buff-命令光环',
    'buff-耐久光环',
    'buff-恢复光环'
}

local all_creep = {}
local all_food 
for k,v in pairs(ac.table.UnitData) do
    if v.type then 
        if finds(v.type,'喽喽','小怪','头目','boss') then
            if not all_creep[v.type] then 
                all_creep[v.type] = {}
            end
            table.insert(all_creep[v.type],k)    
            -- print(k,v.type) 
        end    
    end    
    if v.category =='进攻怪' then
        all_food = v.all_food
    end    
end    


--搜索离单位最近的一个英雄
local function find_hero(unit)
    local point = unit:get_point()
    local num = 99999
    local ret = nil 
    for i = 1,10 do 
        local player = ac.player(i)
        local hero = player.hero
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




local mt = ac.creep['刷怪']{    
    region = '',
    creeps_datas = '',
    is_random = true,
    tip ="郊区野怪刷新啦，请速速打怪升级，赢取白富美"

}
function mt:on_start()
    local rect = require 'types.rect'
    local region = rect.create('-2000','-2000','2000','2000')
    self.region = region
end
function mt:on_next()
    --每一波开始时，进行初始化数据
    self.all_food = all_food
    self.used_food = 0 
    self.current_creep ={}
    
    --查找当前波野怪数据是否已经有此类型的怪
    -- 类型或是名字都可查找
    local function has_unit(str)
        -- print('打印当前野怪',self.current_creep)
        local u
        for k,v in pairs(self.current_creep) do
            if v.type == str or v.name == str then 
                u = v
                break
            end    
        end   
        return u 
    end    
    local type = {'喽喽','小怪','头目','boss'}
    local int = math.random(1,2)
    local temp_type ={}

    for i=1,int do 
        local random_ty = type[math.random(1,#type)]
        if temp_type[1] and temp_type[1] == random_ty then 
            i = 1
        else
            table.insert(temp_type,random_ty) 
        end    
        
    end    
    print('本回合怪物：'..int)
    --随机生成野怪数据
    local function random_creeps_datas()

        local rand_type = temp_type[math.random(1,#temp_type)]

        local rand_name
        local u = has_unit(rand_type)
        if u then 
            rand_name = u.name
        else    
            rand_name = all_creep[rand_type][math.random(1,#all_creep[rand_type])]
        end    

        self.used_food = self.used_food  + ac.table.UnitData[rand_name].food
        -- print('人口情况：',self.used_food,all_food)

        if self.used_food <= all_food then 
            local u = has_unit(rand_type)
            if u then
                self.current_creep[rand_name]['cnt'] = self.current_creep[rand_name]['cnt'] +1
            else 
                --保存当前生成的数据
                for k,v in pairs(ac.table.UnitData[rand_name]) do
                    if not self.current_creep[rand_name]  then 
                        self.current_creep[rand_name] = {}
                    end 
                    self.current_creep[rand_name]['name'] =  rand_name
                    self.current_creep[rand_name]['cnt'] =  1
                    self.current_creep[rand_name][k]=v 
                end    
            end

            if self.used_food == all_food then 
                local result = ''
                for k,v in pairs(self.current_creep) do
                    result = result ..v.name..'*'..tostring(v.cnt)..' '
                end   
                -- print('函数内的返回结果',result)
                -- 没搞懂return 外面没接收到值
                self.creeps_datas = result
                return result
            end    

            random_creeps_datas()

        else
            self.used_food = self.used_food - ac.table.UnitData[rand_name].food 
            print('已经超出人口，需要重新筛选',self.used_food)
            random_creeps_datas()
        end       

    end

    random_creeps_datas()

    print(self.creeps_datas)

    --转化字符串 为真正的区域
    self:set_region()
    --转化字符串 为真正的野怪数据
    self:set_creeps_datas()

    print('当前波数 '..self.index)
end
--改变怪物
function mt:on_change_creep(unit,lni_data)
  
    local name = '进攻怪-'..self.index
    local data = ac.table.UnitData[name]

    if unit and data  then 
    --    unit.gold = math.random(data.gold[1],data.gold[2])
        unit.gold = data.gold
        unit.exp = data.exp
        unit.category = data.category
        for k,v in pairs(data.attribute) do 
            unit:set(k,v)
        end
         --设置 boss 等 属性倍数
         if lni_data.attr_mul  then

            --属性
            unit:set('攻击',data.attribute['攻击'] * lni_data.attr_mul)
            unit:set('护甲',data.attribute['护甲'] * lni_data.attr_mul)
            unit:set('生命上限',data.attribute['生命上限'] * lni_data.attr_mul)
            unit:set('魔法上限',data.attribute['魔法上限'] * lni_data.attr_mul)
            unit:set('生命恢复',data.attribute['生命恢复'] * lni_data.attr_mul)
            unit:set('生命恢复',data.attribute['生命恢复'] * lni_data.attr_mul)

            --掉落概率
            unit.fall_rate = data.fall_rate * lni_data.attr_mul

            --掉落金币和经验
            unit.gold = data.gold * lni_data.attr_mul
            unit.exp = data.exp * lni_data.attr_mul
           
        end  

    end 

    unit:event '单位-死亡' (function(_,unit,killer)
        --加钱
        local player = killer:get_owner()
        player:addGold(unit.gold,unit,true)

        --加经验,100级最高级
        if killer:is_hero() and killer.level <100 then
            killer:addXp(unit.exp)
        end
    end);

end


--回合结束时，创建钥匙怪，打死才能进入下一回合
ac.game:event '游戏-回合结束' (function(trg,index, creep) 

    local self = creep
    local unit = ac.player[16]:create_unit('钥匙怪',ac.point(0,0))

    unit:set('移动速度',800)

    --每1秒 与距离最近英雄的反方向 跑
    local hero = find_hero(unit)
    local angle = hero:get_point()/unit:get_point()
    --优化钥匙怪跑路角度
    angle = angle - math.random(0,360)
    local target_point = unit:get_point() - {angle,1044}
    unit:issue_order('move',target_point)

    unit:loop(2*1000,function()
        local hero = find_hero(unit)
        local angle
        if hero then  
            angle= hero:get_point()/unit:get_point()
        else 
            angle =math.random(0,360)
        end    
        --优化钥匙怪跑路角度
        angle = angle - math.random(0,360)
        local target_point = unit:get_point() - {angle,1044}
        unit:issue_order('move',target_point)

    end);

    unit:event '单位-死亡' (function(_,unit,killer)
         --如果有刷新时间配置 则 按照时间等待后刷新，没有的话立即刷新
         if self.cool then 
            ac.wait(self.cool  * 1000, function()
                self:next()
            end)
        else
            --最小刷新时间
            --print('等待0.1秒刷新')
            ac.wait(0.3 * 1000, function()
                self:next()
            end)
        end	
    end)    

    return true
end);

-- 注册英雄杀怪得奖励事件



--进入游戏后3秒开始刷怪
ac.wait(1000,function()
    --开始刷怪
    mt:start()

    --每3秒刷新一次攻击目标
    ac.loop(3 * 1000 ,function ()
        for _, unit in ipairs(mt.group) do
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

end);
