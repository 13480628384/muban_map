local mt = ac.skill['法力流失']

function mt:boss_skill_shot()
    local hero = self.owner
    local target = self.target
    local skill = self
    local damage_data = skill:damage_data_cal()
    
    for _,u in ac.selector()
        : in_range(target,skill.area)
        : is_enemy(hero)
        : ipairs()
    do
	    u:set('魔法',u:get('魔法')*skill.rate/100)
	    u:add_buff '法力流失-BUFF'
	    {
	    	skill = skill,
	    	time = skill.time,
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


local mt = ac.buff['法力流失-BUFF']
mt.pulse = 0.1
function mt:on_pulse()
	self.target:set('魔法',0)
end