
local mt = ac.skill['龙破斩']

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local target = self.target
    local damage_data = skill:damage_data_cal()
    
    local lt = ac.lightning('CLPB',hero,target,50,50)
    lt.speed = -4

    skill:damage
    {
        source = hero,
        target = target,
        damage = damage_data.damage,
        damage_type = damage_data.damage_type,
    }

end

function mt:on_cast_start()
    self.eft = ac.warning_lightning
    {
        hero = self.owner,
        target = self.target,
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
