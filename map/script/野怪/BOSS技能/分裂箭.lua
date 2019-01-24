
local mt = ac.skill['分裂箭']

function mt:on_add()
	local hero = self.owner
	local skill = self

	self.trg = hero:event '单位-攻击出手'  (function(_, damage)
		local num = skill.num
		for _,u in ac.selector()
			: in_range(hero,hero:get('攻击范围'))
			: is_enemy(hero)
			: ipairs()
		do
			if u ~= damage.target then
				local mover_data = ac.mover.target
				{
					source = hero,
					target = u,
					path = true,
					speed = 1000,
					model = [[Abilities\Weapons\Arrow\ArrowMissile.mdl]],
					height = 100,
					damage = hero:get('攻击'),
					skill = false,
				}

				--弹道击中目标时造成伤害
				function mover_data:on_finish()
					if u:is_alive() then
						skill:damage
						{
							source = hero,
							target = u,
							damage = mover_data.damage,
							damage_type = '物理',
						}
					end
				end

				num = num - 1
				if num <= 0 then
					return
				end
			end
		end

		hero:add_buff '分裂箭-加速'
		{
			skill = skill,
			rate = skill.spd_up,
			time = skill.time,
		}
		
	end)
end

local mt = ac.buff['分裂箭-加速']
function mt:on_add()
	self.target:add('攻击速度',self.rate)
end
function mt:on_remove()
	self.target:add('攻击速度',-self.rate)
end