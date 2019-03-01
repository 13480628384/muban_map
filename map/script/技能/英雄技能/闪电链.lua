
local mt = ac.skill['闪电链']
mt{
	--初始等级
	level = 1,
	--技能图标
	art = [[icon\card1_2.blp]],
	--技能说明
	title = '闪电链',
	tip = [[
		攻击有 %chance% %的概率对 %area% 范围造成物理伤害  (%damage%)
	]],
	--弹射范围(直径)
	area = 1000,
	--概率%
	chance = 100,
	damage = function(self,hero)
		return self.owner:get('智力')*1+1200
	end	,
	--是否被动
	passive = true,
	--弹射次数
	time = 15,
	--冷却
	cool = 0,
}
mt.ref = 'origin'
mt.model = [[Abilities\Weapons\Bolt\BoltImpact.mdl]]

function mt:atk_pas_shot(damage)
	local hero = self.owner
	local skill =self
	local target = damage.target

	local tm = skill.time+1
	local unit = hero
	local next = target
	local timer

	local function shot()
		next:add_effect(skill.ref,skill.model):remove()
		next:damage
		{
			source = hero,
			skill = skill,
			target = next,
			damage = skill.damage,
			damage_type = skill.damage_type,
		}
		--hero:add_buff '闪电链-特效'
		--{
		--	skill = skill,
		--	unit1 = unit,
		--	unit2 = next,
		--	time = 1,
		--}
		local lt = ac.lightning('LN06',unit,next,50,50)
		--local lt = ac.lightning('FFAC',unit,next,50,50)
		lt.speed = -3
		
		local group = {}
		for _,u in ac.selector()
			: in_range(hero,skill.area/2)
			: is_enemy(hero)
			: ipairs()
		do
			if u ~= next then
				table.insert(group,u)
			end
		end
		if #group > 0 then
			unit = next
			next = group[math.random(1,#group)]
		else
			timer:remove()
		end
		tm = tm - 1

		if tm <= 0 then
			timer:remove()
		end
	end
	
	timer = ac.loop(0.3*1000,function()
		shot()
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

--local mt = ac.buff['闪电链-特效']
--mt.cover_type = 1
--
--function mt:on_add()
--	--CLPB
--	--CLSB
--end
--function mt:on_remove()
--	--self.lt:remove()
--end