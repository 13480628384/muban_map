local mt = ac.skill['吸血']

mt.ref = 'origin'
mt.model = [[Abilities\Spells\Undead\VampiricAura\VampiricAura.mdl]]

function mt:on_add()

    local hero = self.owner 
    local life_rate = self.life_rate / 100
 
    self.effect = hero:add_effect(self.ref, self.model)

    self.trg = hero:event '造成伤害开始' (function (_,damage)

        if damage:is_common_attack() == false then 
            return 
        end 

        hero:add('生命',hero:get('生命上限') * life_rate)
    end)


end


function mt:on_remove()
    if self.trg then 
        self.effect:remove()

        self.trg:remove()
        self.trg = nil

    end 
end

