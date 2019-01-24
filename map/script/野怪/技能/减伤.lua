local mt = ac.skill['减伤']

mt.ref = 'overhead'
mt.model = [[Abilities\Spells\Undead\AntiMagicShell\AntiMagicShell.mdl]]

function mt:on_add()

    local hero = self.owner 
    local damage_base = self.damage_base 
 
  

    self.trg = hero:event '受到伤害前效果' (function (_,damage)
        if damage:get_current_damage() > damage_base then 
            local effect = hero:add_effect(self.ref, self.model)
            effect:remove()
            damage.damage_type = '真实'
            damage:set_current_damage(damage_base)
        end 
    end)


end


function mt:on_remove()
    if self.trg then 

        self.trg:remove()
        self.trg = nil

    end 
end

