
local mt = ac.skill['骚灵']
mt.model = [[Abilities\Spells\Orc\HealingWave\HealingWaveTarget.mdl]]
function mt:boss_skill_shot()
    local hero = self.owner
    local skill =self
    local target = self.target
    local damage_data = skill:damage_data_cal()

    local mvr = ac.mover.target
    {
        source = hero,
        target = hero,
        mover = target,
        speed = 0,
        accel = 600,
        max_speed = 1500,
        skill = skill,
    }
    self.mvr = mvr
    local buff = target:add_buff '晕眩'
    {
        skill = skill,
        time = 10,
        effect_data = {
            ['chest'] = [[Abilities\Spells\Undead\Cripple\CrippleTarget.mdl]],
        }
    }

    function mvr:on_finish()
        if buff then
            buff:remove()
        end
        target:add_buff '晕眩'
        {
            skill = skill,
            time = skill.time,
            effect_data = {
                ['chest'] = [[Abilities\Spells\Undead\Cripple\CrippleTarget.mdl]],
            }
        }
        skill:stop()
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
