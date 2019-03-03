local mt = ac.skill['阳光枪']
mt{
	--初始等级
	level = 1,
	--技能图标
	art = [[icon\card1_28.blp]],
	--技能说明
	title = '阳光枪',
	tip = [[
	攻击有 %chance% %的概率对 %hit_area% 范围造成物理伤害 (%damage%)
	伤害:智力+1200
	]],
	--范围
	hit_area = 150,
	distance = 900,
	--概率%
	chance = 100,
	damage = function(self,hero)
		if self and self.owner then 
		return self.owner:get('智力')*1+1200
		end
	end	,
	--是否被动
	passive = true,
	--伤害类型
	damage_type = '物理',


}
mt.effect_data = {
	['chest'] = [[Abilities\Weapons\Bolt\BoltImpact.mdl]],
}

function mt:atk_pas_shot(damage)
	local hero = self.owner
	local skill =self
	local target = damage.target
	local mvr = ac.mover.line
	{
		source = hero,
		skill = skill,
		model = [[[TX]ES_Q.mdl]],
		speed = 900,
		angle = hero:get_point()/target:get_point(),
		hit_area = skill.hit_area,
		distance = skill.distance,
		high = 50,
		size = 1,
	}
	if mvr then
		for key,value in pairs(skill.effect_data) do 
			mvr.mover:add_effect(key,value)
		end	
		function mvr:on_hit(u)
			u:damage
			{
				source = hero,
				target = u,
				skill = skill,
				--damage = 100,
				damage = skill.damage,
				damage_type = skill.damage_type,
			}
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
		--添加效果
		for key,value in pairs(skill.effect_data) do 
			hero:add_effect(key,value)
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
