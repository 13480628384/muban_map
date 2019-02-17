local jass = require 'jass.common'
local mt = ac.skill['火矛']


function mt:on_add()
    local hero = self.owner
    local damage_base = self.damage_base 
    local time = self.time 

    self.trg = hero:event '造成伤害开始' (function (_,damage)
        
        if damage:is_common_attack() == false then 
            return 
        end 

        local target = damage.target
        target:add_buff '灼伤'
        {
            source = hero,
            damage = damage_base,
            time = time,
            skill = self,
        }
        
    end)

    self.old_weapon = hero.weapon
    hero.weapon = {
        ['弹道模型'] = [[Abilities\Weapons\FlamingArrow\FlamingArrowMissile.mdl]],
        ['弹道速度'] = 2000,
        ['弹道弧度'] = 0.15,
        ['弹道出手'] = {15, 0, 66},
    }
end 

function mt:on_remove()
    local hero = self.owner
    hero.weapon = self.old_weapon
    if self.trg then 
       
        self.trg:remove()
        self.trg = nil
    end 
end
