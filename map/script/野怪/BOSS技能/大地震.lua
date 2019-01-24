local mt = ac.skill['大地震']
mt.effect = [[war3mapImported\-!boom10!-.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local damage_data = skill:damage_data_cal()
    
    local function shot()
        ac.effect_ex
        {
            point =  hero:get_point(),
            model = skill.effect,
            size = skill.area/250,
        }:remove()
        for _,u in ac.selector()
            : in_range(hero,skill.area)
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
            u:add_buff '减速'
            {
                skill = skill,
                time = skill.time,
                move_speed_rate = skill.spd_div,
            }
        end
    end
    shot()
    ac.timer(1*1000,skill.num - 1,function()
        shot()
    end)
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