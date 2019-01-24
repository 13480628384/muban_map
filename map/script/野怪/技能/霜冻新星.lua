local mt = ac.skill['霜冻新星']


function mt:on_add()

    local hero = self.owner 
 
    if not hero:is_type('野怪') then 
        return 
    end 
    
    --给野怪注册自动释放的ai

    self.trg = hero:event '造成伤害开始' (function (_,damage)
        local target = damage.target

        if damage:is_common_attack() == false then 
            return 
        end 

        if self:get_cd() == 0 then 

            hero:cast('霜冻新星',target)
        end 
        
    end)


end

function mt:on_cast_shot()
    local hero = self.owner 
    local target = self.target 
    local point = target:get_point()
    local effect = point:effect
    {
        model = [[Abilities\Spells\Undead\FrostNova\FrostNovaTarget.mdl]],
    }
    effect:remove()

    target:damage
    {
        source = hero,
        damage = self.damage_base, 
        skill = self,
        aoe = true,
    }

end 


function mt:on_remove()
    if self.trg then 

        self.trg:remove()
        self.trg = nil

    end 
end

