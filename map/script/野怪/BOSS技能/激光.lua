
local mt = ac.skill['激光']
mt.model = [[Abilities\Spells\Orc\HealingWave\HealingWaveTarget.mdl]]
function mt:boss_skill_shot()
    local hero = self.owner
    local skill =self
    local target = self.target
    local damage_data = skill:damage_data_cal()

    local tm = skill.num + 1
    local unit = hero
    local next = target
    local timer
    local group = {}

    local function shot()
        next:add_effect(skill.ref,skill.model):remove()
        group[next] = true
        skill:damage
        {
            source = hero,
            target = next,
            damage = damage_data.damage,
            damage_type = damage_data.damage_type,
        }
        next:add_buff '激光-致盲'
        {
            skill = skill,
            source = hero,
            time = skill.time,
        }
        --hero:add_buff '闪电链-特效'
        --{
        --	skill = skill,
        --	unit1 = unit,
        --	unit2 = next,
        --	time = 1,
        --}
        local lt = ac.lightning('FFAA',unit,next,50,50)
		lt:setColor(70,70,100)
        lt.speed = -2
        
        local group = {}
        for _,u in ac.selector()
            : in_range(hero,skill.range/2)
            : is_enemy(hero)
            : ipairs()
        do
            if u ~= next and not group[u] then
                table.insert(group,u)
            end
        end
        if #group > 0 then
            unit = next
            next = group[math.random(1,#group)]
        else
            timer:remove()
        end
        tm = tm - 1

        if tm <= 0 then
            timer:remove()
        end
    end

    timer = ac.loop(0.05*1000,function()
        shot()
    end)
end

function mt:on_cast_start()
    self.eft = ac.warning_lightning
    {
        hero = self.owner,
        target = self.target,
        time = self.cast_channel_time,
    }
    self.buf = self.owner:add_buff '施法距离限制'
    {
    	skill = self,
    	unit = self.target,
    	range = self.range,
    }
end

function mt:on_cast_shot()
    self:boss_skill_shot()
end

function mt:on_cast_stop()
    if self.eft then
        self.eft:remove()
    end
    if self.buf then
	    self.buf:remove()
    end
end

function mt:on_remove()
end


local mt = ac.buff['激光-致盲']
mt.effect_data = {
    ['head'] = [[Abilities\Spells\NightElf\Barkskin\BarkSkinTarget.mdl]]
}

function mt:on_add()
    local target = self.target
    self.trg = target:event '造成伤害开始'(function(_,damage)
        if not damage:is_common_attack() then return end
        return true
    end)
end

function mt:on_remove()
    if self.trg then
        self.trg:remove()
    end
end
