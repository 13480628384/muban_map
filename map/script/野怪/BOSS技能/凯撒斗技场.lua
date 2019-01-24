local mt = ac.skill['凯撒斗技场']
mt.effect = [[war3mapImported\lighwave1.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local damage_data = skill:damage_data_cal()

    hero:add_buff '凯撒斗技场-buff'
    {
        source = hero,
        point = hero:get_point(),
        range = skill.area,
        time = skill.time,
        skill = skill,
    }
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


local mt = ac.buff['凯撒斗技场-buff']
mt.pulse = 0.03

function mt:on_add()
    self.group = {}
    self.eft = ac.effect_ex
    {
        model = self.skill.effect,
        point = self.point,
        size = self.range/70,
    }
end

function mt:on_remove()
    if self.eft then
        self.eft:remove()
    end
end

function mt:on_pulse()
	local hero = self.target
    local skill = self.skill
    local group = self.group
	
    for _,u in ac.selector()
        : in_range(self.point,self.range)
        : is_enemy(hero)
        : ipairs()
    do
        if not group[u] then
            group[u] = true
        end
    end
    for u,v in pairs(group) do
        if u:get_point() * self.point > self.range then
            u:blink( self.point - { self.point/u:get_point(), self.range} )
        end
    end
end