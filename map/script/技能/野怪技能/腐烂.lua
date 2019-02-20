local mt = ac.skill['腐烂'] 

mt{
    level = 1,
    title = "腐烂",
    tip = [[
        被动1：死亡时，对凶手单位造成每秒1%最大生命值的伤害，持续60秒
        被动2：降低自己的三维40%
    ]],

    -- 影响三维值 (怪物为：生命上限，护甲，攻击力)
    value = 40,
   
    -- 持续时间
    time = 60,

    -- 最大生命值伤害
    life_rate = 1,
    -- 每秒
    pulse = 1,
    -- 特效
    effect = [[Abilities\Spells\Undead\PlagueCloud\PlagueCloudCaster.mdl]]

}


function mt:on_add()
    local skill = self
    local hero = self.owner 
    -- 降低三维(生命上限，护甲，攻击)
    hero:add('生命上限%', -self.value)
    hero:add('护甲%', -self.value)
    hero:add('攻击%', -self.value)


    self.trg = hero:event '单位-死亡' (function (_,unit,killer)
        
        killer:add_buff '腐烂' 
        {
            source = hero,
            skill = self,
            pulse = self.pulse,
            damage = killer:get('生命上限')*self.life_rate/100,
            effect = self.effect,
            time = self.time
        }
            
    end)

end


function mt:on_remove()

    local hero = self.owner 
    -- 提升三维(生命上限，护甲，攻击)
    hero:add('生命上限%', self.value)
    hero:add('护甲%', self.value)
    hero:add('攻击%', self.value)

    if self.trg then
        self.trg:remove()
        self.trg = nil
    end    

end


local mt = ac.buff['腐烂']
mt.cover_type = 1
mt.cover_max = 1

function mt:on_add()
    self.eff = self.target:add_effect('chest',self.effect)
end

function mt:on_remove()
	self.eff:remove()
end

function mt:on_pulse()
    -- print('腐烂每秒伤害：',damage*self.pulse)
	self.target:damage
	{
		source = self.source,
		damage = self.damage,
        skill = self.skill,
        real_damage = true
	}
end

function mt:on_cover(new)
	if new.time > self:get_remaining() then
		self:set_remaining(new.time)
	end
	return false
end
