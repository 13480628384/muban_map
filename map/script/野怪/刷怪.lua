-- 每回合刷 25 人口的怪物
-- 喽喽占 1个人口，小怪占 2个人口，头目占4人口，boss占20人口
-- 小怪、头目、boss属性是喽喽的多倍
-- 每个回合刷的 同怪物类型 的怪物都是同样。

--boss 光环列表
local buff_list = {
}
--技能列表
ac.skill_list = {
    '肥胖','强壮','钱多多','经验多多','物品多多',
    '神盾','闪避+','闪避++','眩晕','生命回复',
    '重生','死亡一指','灵丹妙药','刺猬','怀孕',
    '抗魔','魔免','火焰','净化','远程攻击',
    '幽灵','腐烂','流血','善恶有报',
    '沉默光环','减速光环'
}

local skill_list = ac.skill_list

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

--每回合开始 从 ac.skill_list 随机取0-2个野怪技能
local function get_creep_skill()

    local rand_skill_cnt = math.random(0,2)
    local rand_skill_list = {}
    if rand_skill_cnt == 0 then 
        return 
    end  
    for i = 1,rand_skill_cnt do  
        local rand_skill_name = ac.skill_list[math.random(#ac.skill_list)]
        table.insert(rand_skill_list,rand_skill_name)
    end    
    return rand_skill_list

end
--给野怪添加技能 
--技能列表
--野怪单位
local function add_creep_skill(tab,unit)
    if not tab or #tab == 0 then 
        return 
    end    
    local prtin_str =''
    for i = 1,#tab do  
        local skill_name = tab[i]
        local skill = ac.skill[skill_name]
        --如果技能是光环
        if skill.is_aura then 
            -- 初始化时 创建一个敌对单位马甲
            if ac.enemy_unit and ac.enemy_unit:find_skill(skill_name) then 
                -- print('光环马甲单位已经添加过')
            else
                ac.enemy_unit = ac.player.com[2]:create_dummy('e001', ac.point(0,0),0)
                ac.enemy_unit:add_restriction '无敌' 
                ac.enemy_unit:add_skill(skill_name,'隐藏')
                -- 本回合结束时 删掉干掉光环怪
                ac.game:event '游戏-回合结束'(function(trg,index, creep) 
                    print('回合结束，删掉光环怪')
                    ac.enemy_unit:remove()
                end)
            end    
        else
            if not unit:find_skill(skill_name) then 
                unit:add_skill(skill_name,'隐藏')    
            end    
        end    
        
        prtin_str = prtin_str .. i .. skill_name ..','
    end 
    -- unit:add_skill('火焰','隐藏')    
    print('1111111111本回合野怪技能：',prtin_str)
end    


local mt = ac.creep['刷怪']{    
    region = '',
    creeps_datas = '',
    is_random = true,
    creep_player = ac.player.com[2],
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
        local random_ty  
        if i < 2  then 
            random_ty = type[math.random(1,#type)]
        else
            --如果时随机到两种怪，第二种怪不允许是boss
            random_ty = type[math.random(1,3)]
        end    
        -- if temp_type[1] and temp_type[1] == random_ty then 
        --     i = 1
        -- else
            table.insert(temp_type,random_ty) 
        -- end    
        
    end    
    -- print('本回合怪物种类：'..int)
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

    self.rand_skill_list = get_creep_skill()

    --发送本层怪物特性 
    --@次数
    --@持续时间
    local function send_skill_message(cnt,time)
        local creep_skill_message ='|cff1FA5EE本层怪物特性：|r|cffFF9800'
        if not self.rand_skill_list  then 
            creep_skill_message = creep_skill_message ..'无|r'
        else    
            for i = 1,#self.rand_skill_list do  
                creep_skill_message = creep_skill_message .. self.rand_skill_list[i]..','
            end
        end    
        creep_skill_message = creep_skill_message ..'|r'
        for x=1,cnt do 
            for i = 1,10 do 
                ac.player(i):sendMsg(creep_skill_message,time)
            end  
        end    
    end  
    --发送本层怪物信息 3次5秒
    send_skill_message(3,10)
    print('当前波数 '..self.index)
end
--改变怪物
function mt:on_change_creep(unit,lni_data)
  
    local name = '进攻怪-'..self.index
    local data = ac.table.UnitData[name]
    data.attr_mul = lni_data.attr_mul
    data.food = lni_data.food
    --继承进攻怪lni 值
    for k,v in pairs(data) do 
        unit.data[k] = v
    end    
  
    if unit and data  then 
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
            unit:set('魔法恢复',data.attribute['魔法恢复'] * lni_data.attr_mul)
        end  
        --掉落概率
        unit.fall_rate = data.fall_rate * lni_data.food
        --掉落金币和经验
        unit.gold = data.gold * lni_data.food
        unit.exp = data.exp * lni_data.food

    end 
    --设置搜敌路径
    -- unit:set_search_range(99999)
    --add_creep_skill(self.rand_skill_list,unit)
    --随机添加怪物技能
    --unit:add_skill('怀孕','隐藏')
    -- unit:add_skill('霜冻新星','隐藏')
    -- unit:add_skill('肥胖','隐藏')
    -- unit:add_skill('强壮','隐藏')
    -- unit:add_skill('有钱','隐藏')
    -- unit:add_skill('学习','隐藏')
    -- unit:add_skill('收藏','隐藏')
    -- unit:add_skill('神盾','隐藏')
    -- unit:add_skill('躲猫猫','隐藏')
    -- unit:add_skill('我晕','隐藏')
    -- unit:add_skill('泡温泉','隐藏')
    -- unit:add_skill('重生','隐藏')
    -- unit:add_skill('死亡一指','隐藏')
    -- unit:add_skill('学霸','隐藏')
    -- unit:add_skill('刺猬','隐藏')
    -- unit:add_skill('怀孕','隐藏')
    -- unit:add_skill('抗魔','隐藏')
    -- unit:add_skill('魔免','隐藏')
    -- unit:add_skill('火焰','隐藏')
    -- unit:add_skill('净化','隐藏')
    -- unit:add_skill('远程攻击','隐藏')
    -- unit:add_skill('幽灵','隐藏')
    -- unit:add_skill('腐烂','隐藏')
    -- unit:add_skill('流血','隐藏')
    unit:add_skill('善恶有报','隐藏')
    

end


--回合结束时，创建钥匙怪，打死才能进入下一回合
ac.game:event '游戏-回合结束' (function(trg,index, creep) 
    -- print('游戏-回合结束，即将创建钥匙怪')
    local self = creep
    local unit = ac.player[16]:create_unit('钥匙怪',ac.point(0,0))
    ac.key_unit = unit
    -- print('钥匙怪队伍：',unit:get_team())
    local name = '进攻怪-'..self.index
    local data = ac.table.UnitData[name]

    --设置属性
    unit.category = '进攻怪' --设置为进攻怪的掉落物品规则
    unit.gold = data.gold * 5 
    unit.exp = data.exp * 5
    unit.fall_rate = data.fall_rate * 5
    unit:set('移动速度',800)
    --设置掉落技能书概率 暂时没实现
    unit.fall_skill_book = 20

    --逃跑路线
    local hero = ac.find_hero(unit)
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

    unit:loop(2*1000,function()
        local hero = ac.find_hero(unit)
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

    --  return true
end);

-- 注册英雄杀怪得奖励事件
ac.game:event '单位-死亡' (function(_,unit,killer) 
    local player = killer:get_owner()
    local gold 
    local exp 
    
    -- 英雄的召唤物 打死的怪，也给英雄加钱加经验
    -- 英雄召唤物享有 英雄的金币、经验加成
    if player and not killer:is_hero()  then 
        killer = player.hero
    end   
    -- 进攻怪杀死单位，不用加钱和经验
    if not killer then  
        return
    end    
    --加钱
    if unit.gold  then 
        gold = unit.gold * ( 1 + killer:get('金币加成')/100)
        player:addGold(gold,unit,true)
    end   
     
    --加经验,100级最高级
    if unit.exp  and killer.level <100 then
        exp = unit.exp * ( 1 + killer:get('经验加成')/100)
        killer:addXp(exp)
    end

end);


    

--进入游戏后3秒开始刷怪
ac.wait(0,function()
    ac.game:event '游戏-开始' (function()
        --开始刷怪
        mt:start()
         --每3秒刷新一次攻击目标
        ac.loop(3 * 1000 ,function ()
            for _, unit in ipairs(mt.group) do
                -- print('野怪区的怪',unit:get_name())
                if unit:is_alive() then 
                    local hero = ac.find_hero(unit)
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
            end 
        end)
    end)

   

end);
