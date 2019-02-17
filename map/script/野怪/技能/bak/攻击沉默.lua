local mt = ac.skill['攻击沉默']


function mt:on_add()

    local hero = self.owner 
    local mp = self.mp
 
 
    self.effect = hero:add_effect(self.ref, self.model)

    self.trg = hero:event '造成伤害开始' (function (_,damage)
        local target = damage.target

        if damage:is_common_attack() == false then 
            return 
        end 
           
        if hero:is_ally(damage.target) then 
            return 
        end 

        if damage.target:has_restriction '魔免' then 
            return
        end 
        if math.random(100) <= self.value then 
            damage.target:add_buff '沉默'
            {
                time = self.time 
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

