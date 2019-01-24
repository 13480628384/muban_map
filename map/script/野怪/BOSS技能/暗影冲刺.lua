
local mt = ac.skill['暗影冲刺']
mt.model = [[Abilities\Spells\Orc\HealingWave\HealingWaveTarget.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill =self
    local target = self.target
    local damage_data = skill:damage_data_cal()
    if target and target:is_alive() then
    else
        return
    end
    local mvr = ac.mover.target
    {
        skill = skill,
        source = hero,
        mover = hero,
        speed = 700,
        hit_area = 120,
        target = target,
        do_reset_high = true,
    }

    local effect = hero:add_effect('origin',[[Abilities\Spells\Orc\Shockwave\ShockwaveMissile.mdl]])

    local function hit_unit(u)
        skill:damage
        {
            source = hero,
            target = u,
            damage = damage_data.damage,
            damage_type = damage_data.damage_type,
        }

        local buff = u:add_buff '击退'
        {
            source = hero,
            angle = hero:get_point()/u:get_point(),
            accel = -10,
            distance = 200,
            time = 2,
        }

        u:add_buff '跟随特效'
        {
            hearing = buff,
            model = [[Abilities\Spells\Human\FlakCannons\FlakTarget.mdl]],
            point = true,
            pulse = 0.05,
        }
    end

    if mvr then
        self.mvr = mvr
        hero:set_facing(hero:get_point()/target:get_point())
        
        hero:add_buff '跟随特效'
        {
            hearing = mvr,
            model = [[Abilities\Spells\Human\FlakCannons\FlakTarget.mdl]],
            point = true,
            pulse = 0.05,
        }

        function mvr:on_hit(u)
            hit_unit(u)
        end

        function mvr:on_finish()
            if target:is_alive() then
                hit_unit(target)
            end
            skill:stop()
            if effect then
                effect:remove()
            end
        end

        function mvr:on_remove()
            skill:stop()
            if effect then
                effect:remove()
            end
        end
    end
end

function mt:on_cast_start()
    local skill = self
    self.eft = ac.warning_lightning
    {
        hero = self.owner,
        target = self.target,
        time = self.warning_time,
    }
    self.tm = self.owner:wait(skill.warning_time*1000,function()
        skill:boss_skill_shot()
    end)
    self.buf = self.owner:add_buff '施法距离限制'
    {
    	skill = self,
    	unit = self.target,
    	range = self.range,
    }
end

function mt:on_cast_shot()
end

function mt:on_cast_stop()
    if self.tm then
        self.tm:remove()
    end
    if self.eft then
        self.eft:remove()
    end
    if self.mvr then
        self.mvr:remove()
    end
    if self.buf then
	    self.buf:remove()
    end
end

function mt:on_remove()
end
