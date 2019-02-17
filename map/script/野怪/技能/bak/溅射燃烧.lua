local mt = ac.skill['溅射燃烧']


function mt:on_add()
    local hero = self.owner
    local damage_base = self.damage_base 
    self.trg = hero:event '造成伤害开始' (function (_,damage)
        
        if damage:is_common_attack() == false then 
            return 
        end 

        local target = damage.target
        local point = target:get_point()
                                                                                                                                                  
        
    end)

end 

function mt:on_remove()

    if self.trg then 
        self.trg:remove()
        self.trg = nil
    end 
end
