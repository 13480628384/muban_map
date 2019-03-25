local mt = ac.skill['绿野之矛']
mt{
    --等级
    level = 1,

    --是被动
    passive = true,
	--技能类型
	skill_type = "被动",

    --原始伤害
    damage = function(self,hero)
        return hero:get '力量' * 4 + hero:get '智力' * 5 + hero:get '敏捷' * 4
    end,

    --释放几率
    chance = function (self,hero)
        return 15 + hero:get '天赋触发几率'
    end,

    --投射物数量
    count = 4,
    --图标
    art = 'lvyezhimao.tga',

    --buff持续时间
    time = 3,

    --异步下数据 只作为文本提示

    --投射物数量
    client_count = function(self)
        return 4 + ac.player.self.hero:get '额外投射物数量'
    end,
    --几率
    my_chance = function (self)
        return 15 + ac.player.self.hero:get '天赋触发几率'
    end,

    --投射物模型
    model = [[lvyezhimao.MDX]],
    title = '绿野之矛',
    tip = [[标签：|cff0c97d1投射物|r
%my_chance% % 几率发射 %client_count% 只绿野之矛，35% 几率为友军英雄添加一个治疗Buff,每秒恢复智力*0.3+目标最大生命值 1% 的生命值,持续 %time% 秒
伤害计算：|cffd10c44全属性 * 4|r
伤害类型：|cff04be12法术伤害|r]],
}

function mt:on_add()
    local hero = self.owner
    local skill = self
    --记录默认攻击方式
    if not hero.oldfunc then
        hero.oldfunc = hero.range_attack_start
    end
    --新的攻击方式
    local function range_attack_start(hero,damage)
        if damage.skill and damage.skill.name == self.name then
            return
        end

        local u_group = {}
        local target = damage.target
        local max_damage = self.current_damage
        --投射物数量
        local count = hero:get '额外投射物数量' + self.count - 1
       
		local unit_mark = {}

		for i,u in ac.selector()
			: in_range(hero,hero:get('攻击距离'))
			: is_enemy(hero)
			: of_not_building()
			: sort_nearest_hero(hero) --优先选择距离英雄最近的敌人。
			: set_sort_first(target)
			: ipairs()
     	do
			if i <= count then
				local mvr = ac.mover.target
				{
					source = hero,
					target = u,
					model = self.model,
					speed = 1500,
					skill = skill,
				}
				if not mvr then
					return
                end
                
				function mvr:on_finish()
                    u:damage
                    {
                        source = hero,
                        damage = max_damage,
                        skill = skill,
                        missile = self.mover,
                        damage_type = '法术'
                    }
				end
			end	
        end
        
        --添加buff
        if math.random(100) <= 35 then
            for unit,_ in pairs(ac.hero.all_heros) do
                if unit and not unit.lyzm and unit:is_alive() and not unit:find_buff('绿野之矛') then
                    unit.lyzm = true
                    unit:add_buff '绿野之矛'{
                        skill = self,
                        time = self.time,
                    }
                end
            end
        end
        
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


local mt = ac.buff['绿野之矛']
-- 共存模式
mt.cover_type = 1
-- 只有1个同名buff生效
mt.cover_max = 1

mt.pulse = 1

function mt:on_add()
    local hero = self.target
    self.eff = hero:add_effect('chest',[[Abilities\Spells\NightElf\Rejuvenation\RejuvenationTarget.mdx]])
end

-- 叠加事件
function mt:on_cover(new)
	return false
end

function mt:on_pulse()
	local hero = self.target

    local max_life = hero:get '生命上限'
	hero:heal
	{
		source = hero,
		skill = self.skill,
		heal = max_life  / 100 + self.skill.owner:get '智力' * 0.3,
	}
end


function mt:on_remove()
    local hero = self.skill.owner
    self.eff:remove()
    self.target.lyzm = nil
end
