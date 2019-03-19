
local mt = ac.skill['炎爆术']
mt{
	
	--必填
	is_skill = true,
	--技能类型
	skill_type = "被动",
	--初始等级
	level = 1,
	--技能图标
	art = [[icon\card2_13.blp]],
	--技能说明
	title = '炎爆术',
	tip = [[
		攻击有 %chance% % 的概率对 %area% 范围造成物理伤害  (%damage%)
	]],
	--范围
	area = 1000,
	--概率%
	chance = 10,
	--伤害
	damage = function(self,hero)
		if self and self.owner then 
		return self.owner:get('力量')*3+1200
		end
	end	,
	--是否被动
	passive = true,
	--冷却
	cool = 0.5

}
mt.model = [[war3mapimported\!huobao.mdx]]
mt.model2 = [[Abilities\Weapons\PhoenixMissile\Phoenix_Missile.mdl]]

function mt:atk_pas_shot(damage)
	local hero = self.owner
	local skill =self
	local target = damage.target
	
	local mvr = ac.mover.target
	{
		source = hero,
		target = target,
		skill = skill,
		model = skill.model2,
		speed = 900,
		high = 120,
		size = 1,
	}
	if mvr then
		function mvr:on_finish()
			-- ac.effect_area(30,mvr.mover:get_point(),skill.area, 2, skill.model)
			ac.effect_ex
			{
				point = mvr.mover:get_point(),
				model = skill.model,
				size = skill.area/512,
				speed = 2,
			}
			for _,u in ac.selector()
				: in_range(mvr.mover:get_point(),skill.area)
				: is_enemy(hero)
				: ipairs()
			do
				u:damage
				{
					source = hero,
					skill = skill,
					target = u,
					damage = skill.damage,
					damage_type = skill.damage_type,
				}
			end
		end
	end
end
	
function mt:on_add()
	local hero = self.owner
	local skill = self
	self.trg = hero:event '造成伤害效果' (function(_,damage)
		if not damage:is_common_attack()  then 
			return 
		end 
	
		local rand = math.random(1,100)
		if rand <= self.chance then 
			skill:atk_pas_shot(damage)
		end
	end)
end

function mt:on_remove()
	if self.trg then
		self.trg:remove()
	end
end
