
local mt = ac.skill['火刑']
mt.effect = [[Abilities\Spells\Human\FlameStrike\FlameStrike1.mdl]]
mt.effect2 = [[Abilities\Spells\Human\FlameStrike\FlameStrikeTarget.mdl]]
mt.effect3 = [[Abilities\Spells\Human\FlameStrike\FlameStrikeEmbers.mdl]]
function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local damage_data = skill:damage_data_cal()

    local point_list = {}
    local effect_list = {}
    local effect_list2 = {}
    local effect_list3 = {}
    local pulse = 0.2
    
    local function fire()
        local group = {}
        for i = 1,skill.num do
            for _,u in ac.selector()
                : in_range(point_list[i],skill.area2)
                : is_enemy(hero)
                : ipairs()
            do
                if not group[u] then
                    skill:damage
                    {
                        source = hero,
                        target = u,
                        damage = damage_data.damage * pulse,
                        damage_type = damage_data.damage_type,
                    }
                    group[u] = true
                    u:add_effect('chest',[[Abilities\Weapons\LordofFlameMissile\LordofFlameMissile.mdl]]):remove()
                end
            end
        end
    end

    local timer = ac.timer(pulse*1000,skill.time/pulse,function()
        fire()
    end)

    hero:wait((skill.time+0.05)*1000,function()
        for i = 1,skill.num do
            effect_list[i]:remove()
            effect_list2[i]:remove()
            effect_list3[i]:remove()
        end
    end)

    for i = 1,skill.num do
        point_list[i] = hero:get_point() - {math.random(0,360),math.random(0,skill.area)}
        effect_list[i] = ac.effect_ex
        {
            point = point_list[i],
            model = skill.effect,
            size = skill.area2/200,
        }
        effect_list2[i] = ac.effect_ex
        {
            point = point_list[i],
            model = skill.effect2,
            size = skill.area2/250,
        }
        effect_list3[i] = ac.effect_ex
        {
            point = point_list[i],
            model = skill.effect3,
            size = skill.area2/200*4,
        }
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
end

function mt:on_remove()
end