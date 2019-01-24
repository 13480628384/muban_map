
local mt = ac.skill['产卵']
mt.effect = [[Doodads\Dungeon\Terrain\EggSack\EggSack0.mdl]]
mt.effect2 = [[Abilities\Weapons\GreenDragonMissile\GreenDragonMissile.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local damage_data = skill:damage_data_cal()
    
    local function raining(point)

        local effect = ac.effect_ex
        {
            model = skill.effect,
            point = point,
            size = 1,
        }
        ac.effect_ex
        {
            model = skill.effect2,
            point = point,
            size = 1,
            rotate = {math.random(0,360),math.random(-10,10),math.random(-10,10)}
        }:remove()

        hero:wait(3*1000,function()
            local summon = hero:create_unit('小蜘蛛',point,math.random(1,360))
            if summon then
                ac.F2_InitSummonUnit
                {
                    hero = hero,
                    skill = skill,
                    summon = summon,
                    atr_rate = skill.atr_rate,
                }
                effect:remove()
                summon:wait(skill.time*1000,function()
                    summon:kill()
                end)
                summon.reliveable = 0
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