local mt = ac.skill['疾病迷雾']


function mt:on_add()
    local hero = self.owner
    local damage_base = self.damage_base 
    local time = self.time 
    local move_speed_rate = self.move_speed_rate
    self.trg = hero:event '造成伤害开始' (function (_,damage)
        
        if damage:is_common_attack() == false then 
            return 
        end 

        local target = damage.target
        target:add_buff '疾病迷雾扣血效果'
        {
            source = hero,
            time = time,
            rate = self.life_rate / 100,
            skill = self,
        }
        
    end)
end 

function mt:on_remove()
    if self.trg then 
        self.trg:remove()
        self.trg = nil
    end 
end


local mt = ac.buff['疾病迷雾扣血效果']

mt.cover_type = 1
mt.cover_max = 1

mt.control = 2
mt.debuff = true
mt.pulse = 1

mt.effect_conver = 1 
mt.effect_data = {
	['origin'] = [[Abilities\Spells\Undead\PlagueCloud\PlagueCloudCaster.mdl]]
}

function mt:on_add()
	local hero = self.target
    local count = 0
end

function mt:on_remove()
	local hero = self.target
    local count = 0
end

function mt:on_pulse()
    
    self.target:damage
    {
        source = self.source,
        damage = self.target:get('生命上限') * self.rate,
        skill = self.skill,
        aoe = true,
        damage_type = '真实',
    }

end 


function mt:on_cover(dest)
	--更改原来buff的持续时间
	if dest.time > self:get_remaining() then
		self:set_remaining(dest.time)
	end
	return false
end

