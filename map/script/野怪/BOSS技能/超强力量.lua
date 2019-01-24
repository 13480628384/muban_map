
local mt = ac.skill['超强力量']
mt.model = [[Abilities\Spells\Orc\TrollBerserk\HeadhunterWEAPONSLeft.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self

    hero:add_buff '超强力量-BUFF'
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


local  mt = ac.buff['超强力量-BUFF']
mt.effect_data = {
    ['head'] = [[Abilities\Spells\Orc\TrollBerserk\HeadhunterWEAPONSLeft.mdl]],
    ['hand,right'] = [[Abilities\Spells\Orc\TrollBerserk\HeadhunterWEAPONSLeft.mdl]],
    ['hand,left'] = [[Abilities\Spells\Orc\TrollBerserk\HeadhunterWEAPONSLeft.mdl]],

}
mt.spd = 400

function mt:on_add()
    local hero = self.target
    local skill = self.skill
    local tm = self.num
    local buff = self
    hero:add('攻击速度',buff.spd)
    self.trg = hero:event '单位-攻击开始' (function()
        tm = tm - 1
        if tm <= 0 then
            buff:remove()
        end
    end)
end

function mt:on_remove()
    if self.trg then
        self.trg:remove()
    end
    self.target:add('攻击速度', -self.spd)
end
