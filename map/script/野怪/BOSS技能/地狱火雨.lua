
local mt = ac.skill['地狱火雨']
mt.effect = [[Units\Demon\Infernal\InfernalBirth.mdl]]
mt.effect2 = [[Abilities\Spells\Undead\Impale\ImpaleHitTarget.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local damage_data = skill:damage_data_cal()
    
    local function raining(point)

        ac.effect_ex
        {
            model = skill.effect,
            point = point,
            size = 1.5,
            speed = 0.5,
        }:remove()
        ac.warning_effect_ring
        {
            point = point,
            area = skill.area2,
            time = 0.9 * 2,
        }

        hero:wait(0.9 * 2 * 1000,function()
            local summon = hero:create_unit('地狱火',point,math.random(1,360))
            if summon then
                ac.F2_InitSummonUnit
                {
                    hero = hero,
                    skill = skill,
                    summon = summon,
                    atr_rate = skill.atr_rate,
                }
				local model = 'Infernal_red.mdl'
				japi.SetUnitModel(summon.handle,model)
				
                summon:wait(skill.time*1000,function()
                    summon:kill()
                end)
                summon.reliveable = 0
            end

            for _,u in ac.selector()
                : in_range(point,skill.area2)
                : is_enemy(hero)
                : ipairs()
            do
                skill:damage
                {
                    source = hero,
                    target = u,
                    damage = damage_data.damage,
                    damage_type = damage_data.damage_type,   
                }
                u:add_buff '晕眩'
                {
                    source = hero,
                    time = skill.stun,
                }
            end
        end)
    end

    for i = 1,skill.num do
        raining(hero:get_point()-{math.random(0,360) , math.random(0,skill.area) })
    end
end

function mt:on_add()
	--[[ local hero = self.owner
	local skill = self
	self.trg = hero:event '造成伤害效果' (function(_,damage)
		if ac.attack_skill_rate_cal({hero = hero,skill = skill,damage = damage}) == false then return end
			skill:boss_skill_shot(damage)
	end) ]]
end

function mt:on_cast_start()
    self.eft = ac.warning_effect_ring
    {
        point = self.owner:get_point(),
        area = self.area,
        time = self.cast_channel_time,
    }
end

function mt:on_cast_shot()
    self:boss_skill_shot()
end

function mt:on_cast_stop()
    if self.eft then
        self.eft:remove()
    end
end

function mt:on_remove()
end