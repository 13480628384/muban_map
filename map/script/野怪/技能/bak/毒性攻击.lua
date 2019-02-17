local mt = ac.skill {'毒性攻击','剧毒攻击'}


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
        target:add_buff '中毒'
        {
            source = hero,
            damage = damage_base,
            damage_type = '毒',
            time = time,
            move_speed_rate = move_speed_rate,
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
