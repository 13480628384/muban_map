
local mt = ac.skill['极度饥渴']
mt.model = [[Abilities\Spells\Orc\TrollBerserk\HeadhunterWEAPONSLeft.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self

    hero:add_buff '极度饥渴-BUFF'
    {
        skill = skill,
        time = skill.time,
        num = skill.num, 
    }
end

function mt:on_add()
end

function mt:on_remove()
end

function mt:on_cast_shot()
    self:boss_skill_shot()
end


local  mt = ac.buff['极度饥渴-BUFF']
mt.effect_data = {
    ['origin'] = [[Abilities\Spells\Items\VampiricPotion\VampPotionCaster.mdl]],
    ['hand,right'] = [[Abilities\Spells\Orc\Bloodlust\BloodlustTarget.mdl]],
    ['hand,left'] = [[Abilities\Spells\Orc\Bloodlust\BloodlustTarget.mdll]],

}

function mt:on_add()
    local hero = self.target
    local skill = self.skill
    self.atk = hero:get('攻击')*skill.atk_mul / 100
    hero:add('额外攻击', self.atk)
    
    self.buf = hero:add_buff '攻击吸血'
    {
        skill = skill,
        life_steal = skill.life_steal,
    }
end

function mt:on_remove()
    if self.buf then
        self.buf:remove()
    end
    self.target:add('额外攻击', -self.atk)
end
