local mt = ac.skill['御甲']
mt{
    --等级
    level = 1,

    --是被动
    passive = true,
	--技能类型
	skill_type = "被动",

    --伤害
    damage = function(self,hero)
        return (hero:get '护甲' * 30) * (1 + hero:get '护甲' * (8 / 10000))
    end,

    --释放几率
    chance = function (self,hero)
        return 15 + hero:get '天赋触发几率'
    end,

    --连锁数量
    count = 5,

    --图标
    art = 'yujia.tga',
	--爆炸半径
    hit_area = function(self,hero)
        return 100 + hero:get '额外范围'
    end,

    --异步下数据 只作为文本提示
    areaa = function(self)
        return 100 + ac.player.self.hero:get '额外范围'
    end,

    --连锁次数
    client_count = function(self)
        return ac.player.self.hero:get '额外连锁数量' + 5
    end,

    --几率
    my_chance = function (self)
        return 15 + ac.player.self.hero:get '天赋触发几率'
    end,

    --模型
    model = [[AZ_[Sepll]LinaSun _T2_Blast.MDX]],
    title = '御甲',
    tip = [[标签：|cff0c97d1连锁 范围|r
%my_chance% % 几率发动御甲对单位造成伤害并向周围连锁 %client_count% 次,并对周围 %areaa% 内单位造成 30% 伤害 
伤害计算：|cffd10c44护甲*30(每10点护甲提升0.8%伤害)|r
伤害类型：|cff04be12法术伤害|r]]
}

function mt:on_add()
    local hero = self.owner
    --记录默认攻击方式
    if not hero.oldfunc then
        hero.oldfunc = hero.range_attack_start
    end

    local function range_attack_start(hero,damage)
        if damage.skill and damage.skill.name == self.name then
            return
        end

        local max_damage = self.current_damage
        local target = damage.target
        ac.effect(target:get_point(),self.model,0,1,'origin'):remove()
        target:damage
        {
            source = hero,
            skill = self,
            damage = max_damage,
            damage_type = '法术',
        }

        local count = self.count + hero:get '额外连锁数量' - 1

        --已造成闪电链的单位保存进去
        local group = {}
        table.insert(group,target)

        ac.timer(200,count,function()
            u = ac.selector():in_range(target,700):is_enemy(hero)
            for index, value in ipairs(group) do
                u:is_not(value)
            end
            u = u:random()
            if not u then
                return
            end

            target = u
            table.insert(group,target)
            ac.effect(target:get_point(),self.model,0,1,'origin'):remove()
            target:damage
            {
                source = hero,
                skill = self,
                damage = max_damage,
                damage_type = '法术',
            }

            for _, u_t in ac.selector():in_range(target,self.hit_area):is_enemy(hero):is_not(target):ipairs() do
                u_t:damage
                {
                    source = hero,
                    skill = self,
                    damage = max_damage * 0.3,
                    damage_type = '法术',
                }
            end
        end)

        --还原默认攻击方式
        hero.range_attack_start = hero.oldfunc
    end

	self.trg = hero:event '造成伤害效果' (function(_,damage)
		if not damage:is_common_attack()  then 
			return 
		end 
        --触发时修改攻击方式
        if math.random(100) <= self.chance then
            self = self:create_cast()
            --当前伤害要在回调前初始化
            self.current_damage = self.damage
            hero:event_notify('触发天赋技能', self)

            --hero.range_attack_start = range_attack_start
            range_attack_start(hero,damage)
        end 

        return false
    end)

end


function mt:on_remove()
    local hero = self.owner
    hero.range_attack_start = hero.oldfunc
    self.trg:remove()
end

