local mt = ac.skill['神圣之光']
mt.effect = [[war3mapImported\natureexplosion.mdl]]
mt.effect2 = [[Abilities\Spells\Human\HolyBolt\HolyBoltSpecialArt.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local target = self.target
    local damage_data = skill:damage_data_cal()

    ac.effect_ex
    {
        model = skill.effect,
        point = target,  
        size = skill.area/250
    }:remove()

    for _,u in ac.selector()
        : in_range(target,skill.area)
        : is_ally(hero)
        : ipairs()
    do
        u:add('生命',damage_data.damage)
        u:add_effect('origin',skill.effect2)
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