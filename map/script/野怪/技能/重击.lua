
--2个技能使用同一个脚本
local mt = ac.skill {'重击', '2级重击','3级重击'}


function mt:on_add()
    local hero = self.owner
    local damage_base = self.damage_base 
    local time = self.time 
    local rate = self.attack_rate
    self.trg = hero:event '造成伤害开始' (function (_,damage)
        
        if damage:is_common_attack() == false then 
            return 
        end 
        local rand = math.random(1,100)
        if rand <= rate then 
            local target = damage.target
            damage.target:add_buff '晕眩'
            {
                source = hero,
                time = time,
            }

            damage.target:damage
            {
                source = hero,
                damage = damage_base,
                skill = self,
                aoe = true,
                damage_type = '真实',
            }

        end
    end)
end 

function mt:on_remove()
    if self.trg then 
        self.trg:remove()
        self.trg = nil
    end 
end
