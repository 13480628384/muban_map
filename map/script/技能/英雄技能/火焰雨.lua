
local mt = ac.skill['火焰雨']
mt{
	
	--必填
	is_skill = true,
	--技能类型
	skill_type = "被动",
	--初始等级
	level = 1,
	max_level = 5,
	--技能图标
	art = [[icon\card1_9.blp]],
	--技能说明
	title = '|cff00bdec火焰雨|r',
	tip = [[
	攻击有 %chance% % 的概率对 %area% 范围造成 和智力相关的 法术伤害  (%damage%)
	]],
	--范围
	area = 1500,
	--概率%
	chance = {5,7.5,10,12.5,15},

	int = {2,2.5,3,3.5,4},

	damage = function(self,hero)
		if self and self.owner then 
			return self.owner:get('智力')*self.int+500
		end	
	end	,
	--是否被动
	passive = true,
	--伤害类型
	damage_type = '法术',
	--波次
	tm = 1
}
mt.model = [[Abilities\Spells\Demon\RainOfFire\RainOfFireTarget.mdl]]

function mt:atk_pas_shot(damage)
	local hero = self.owner
	local skill =self
	local target = damage.target
	local point = target:get_point()
	
	local tm = 0
	local timer

	local function raining()
		for i = 1 , 10 do
			ac.effect_ex
			{
				point = point - {math.random(1,360),math.random(30,skill.area/2)},
				model = skill.model,
				size = 0.7
			}:remove()
		end
		hero:wait(0.85*1000,function()
			for _,u in ac.selector()
				: in_range(point,skill.area/2)
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
				u:add_effect('chest',[[Abilities\Weapons\FireBallMissile\FireBallMissile.mdl]]):remove()
			end
		end)
	end

	raining()
	timer = ac.loop(1*1000,function()
		tm = tm + 1
		if tm == skill.tm then
			timer:remove()
		end
		raining()
	end)
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
