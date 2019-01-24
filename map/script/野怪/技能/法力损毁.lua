local mt = ac.skill['法力损毁']


function mt:on_add()

    local hero = self.owner 
    local mp = self.mp
 
    self.effect = hero:add_effect(self.ref, self.model)

    self.trg = hero:event '造成伤害开始' (function (_,damage)
        local target = damage.target

        if damage:is_common_attack() == false then 
            return 
        end 

        target:set('魔法',target:get('魔法') - mp)
        local eff = target:add_effect('origin','Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl')
        
        eff:remove()
        
           
        
    end)


end


function mt:on_remove()
    if self.trg then 
        self.effect:remove()

        self.trg:remove()
        self.trg = nil

    end 
end

