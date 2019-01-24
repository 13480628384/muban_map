local mt = ac.skill['魔力之枷']
mt.model = [[Abilities\Spells\Human\MassTeleport\MassTeleportTo.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local target = self.target
    local damage_data = skill:damage_data_cal()

    local dummy = ac.player[16]:create_dummy('e001', target , 0)
    --dummy:set_high(0)
    dummy.f2_effect = dummy:add_effect('origin', skill.model)

    for _,u in ac.selector()
        : in_range(target,skill.area)
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
        if u:is_alive() then
            local lt = ac.lightning('DRAM',dummy,u,150,80)
            u:add_buff '魔力之枷-束缚'
            {
                source = hero,
                skill = skill,
                source = source,
                time = skill.time,
                dummy = dummy,
                lt = lt,
                dis = skill.area+100,
                damage_data = damage_data,
            }
            u:add_buff '晕眩'
            {
                source = hero,
                time = skill.stun,
            }
        end
    end
    
    dummy:wait(skill.time * 1000,function()
        dummy.f2_effect:remove()
        dummy:remove()
    end)

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
end--[[  ]]

local mt = ac.buff['魔力之枷-束缚']
mt.pulse = 0.1

function mt:lt_break()
    self.skill:damage
    {
        source = self.source,
        target = self.target,
        damage = self.damage_data.damage,
        damage_type = self.damage_data.damage_type,
    }
    self.target:add_buff '晕眩'
    {
        source = self.source,
        skill = self.skill,
        time = self.skill.stun2,
    }
    self:remove()
end

function mt:on_pulse()
    if self.target:get_point() * self.dummy:get_point() > self.dis then
        self:lt_break()
    end
end

function mt:on_remove()
    if self.lt then
        self.lt:remove()
    end
end