local mt = ac.skill['炎魔']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	max_level = 5,
	
	tip = [[
		主动：召唤一个炎魔(属性与智力相关)，它杀死敌人分裂为两个（状态和母体一致）
		被动： 本体 和 召唤物攻击，都附加 智力*1.5的真实伤害 
	]],
	
	--技能图标 
	art = [[ReplaceableTextures\CommandButtons\BTNLavaSpawn.blp]],

	--技能目标类型 无目标
	target_type = ac.skill.TARGET_TYPE_NONE,

	--伤害
	damage = function(self,hero)
		return hero:get('智力')*1.5
	end	,

	--cd 45
	cool = {45,40,35,30,25},

	--耗蓝
	cost = {45,140,235,330,425},

	--数量
	cnt = 1,

	--持续时间
	time = 25,


	--特效模型
	effect = [[Units\Creeps\LavaSpawn\LavaSpawn.mdl]],
	
	
}
function mt:on_add()
	local hero = self.owner 
	local skill = self
	self.trg = hero:event '造成伤害效果' (function(trg, damage)
		if not damage:is_common_attack() then 
			return
		end	
		local target = damage.target
		ac.wait(0.3*1000,function()
			target:damage
			{
				source = hero,
				damage = skill.damage,
				skill = skill,
				real_damage = true
			}
		end)
	end)

end	
local function create_summon_unit(skill,where)
	local hero = skill.owner
	local point = where
	local unit = hero:get_owner():create_unit('炎魔',point)	


	local life_mul, defence_mul, attack_mul = ac.get_summon_mul(hero.level)
	local data = {}
	data.attribute={
		['生命上限'] = hero:get('智力') * life_mul,
		['护甲'] = hero:get('智力') * defence_mul,
		['攻击'] = hero:get('智力') * attack_mul * 1.5,
		['魔法上限'] = 60,
		['移动速度'] = 325,
		['攻击间隔'] = 1.5,
		['生命恢复'] = 1.2,
		['魔法恢复'] = 0.6,
		['攻击距离'] = 800,
	}

	unit:add_buff '召唤物' {
		time = skill.time,
		attribute = data.attribute,
		skill = skill,
	}

	unit:event '单位-杀死单位' (function(trg, killer, target)
		local where = target:get_point() - { math.random(1,360) ,100 }
		create_summon_unit(skill,where)
	end)

	unit:event '造成伤害效果' (function(trg, damage)
		if not damage:is_common_attack() then 
			return
		end	
		local target = damage.target
		ac.wait(0.3*1000,function()
			target:damage
			{
				source = unit,
				damage = skill.damage,
				skill = skill,
				real_damage = true
			}
		end)
	end)

	return unit
end	
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	
	local cnt = (self.cnt + hero:get('召唤物')) or 1
	--多个召唤物
	for i=1,cnt do 
		local where = hero:get_point() - { hero:get_facing(),100 }
		create_summon_unit(skill,where)
	end	
	
end

function mt:on_remove()

    local hero = self.owner 
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
	end   

end
