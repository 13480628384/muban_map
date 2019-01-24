local mt = ac.skill{'暴击','小暴击','中暴击','大暴击'}

function mt:on_add()

    local hero = self.owner 
    --概率
    local crit_chance = self.crit_chance
    --伤害倍数
    local crit_damage_rate = self.crit_damage_rate
    
    self.trg = hero:event '造成伤害开始' (function (_,damage)

        if damage:is_common_attack() == false then 
            return 
        end 
        
        local target = damage.target
        --如果发生这个概率
        if math.random(0, 99) <= crit_chance then 
            damage:add_crit(crit_damage_rate)
        
        end 
    end)
end


function mt:on_remove()
    if self.trg then 
        self.trg:remove()
        self.trg = nil
    end 
end

