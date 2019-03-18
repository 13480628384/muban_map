
local mt = ac.skill['暴风雪']
mt{
	
	--必填
	is_skill = true,
	--初始等级
	level = 1,
	--技能图标
	art = [[icon\card1_32.blp]],
	--技能说明
	title = '暴风雪',
	tip = [[
	攻击有 %chance% % 的概率对 %area% 范围造成法术伤害 (%damage%)
	伤害:智力*4+2000
	]],
	--范围
	area = 425,
	--概率%
	chance = 10,
	--伤害
	damage = function(self,hero)
		if self and self.owner then 
			return self.owner:get('智力')*4+2000
		end	
	end	,
	--是否被动
	passive = true,
	--伤害类型
	damage_type = '法术',
}
mt.model = [[Abilities\Spells\Human\Blizzard\BlizzardTarget.mdl]]

function mt:atk_pas_shot(damage)
	local hero = self.owner
	local skill =self
	local target = damage.target
	local point = target:get_point()
	local num = math.modf(skill.area/2)
	for i = 1 , 20 do
		ac.point_effect(point - {math.random(1,360),math.random(30,num)},{model = skill.model} ):remove()
	end
	hero:wait(0.85*1000,function()
		for _,u in ac.selector()
			: in_range(point,num)
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
			u:add_effect('chest',[[Abilities\Spells\Other\FrostDamage\FrostDamage.mdl]]):remove()
			--skill:damage
			--{
			--	source = hero,
			--	target = u,
			--	damage = damage_data.damage,
			--	damage_type = '魔法',--damage_data.damage_type,
			--}
		end
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
