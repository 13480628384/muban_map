local mt = ac.skill['撕裂大地']
mt.effect = [[Abilities\Spells\Other\Volcano\VolcanoDeath.mdl]]
mt.effect2 = [[Abilities\Spells\Orc\EarthQuake\EarthQuakeTarget.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local target = self.target
    local skill = self
    local damage_data = skill:damage_data_cal()
    ac.effect_ex
    {
        point = target,
        model = skill.effect,
        size = 2.5,
    }:remove()
    ac.effect_ex
    {
        point = target,
        model = skill.effect2,
        size = 2,
        time = 1,
    }   
    for _,u in ac.selector()
        : in_range(target,skill.area)
        : is_enemy(hero)
        : ipairs()
    do
        u:add_buff '晕眩'
        {
            skill = skill,
            source = hero,
            time = skill.stun,
        }
        skill:damage
        {
            source = hero,
            target = u,
            damage = damage_data.damage,
            damage_type = damage_data.damage_type,
        }
    end
end

function mt:on_cast_start()
    self.eft = ac.warning_effect_ring
    {
        point = self.target,
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