local mt = ac.skill['魔法护盾']

mt.ref = 'origin'
mt.model = [[Abilities\Spells\Items\SpellShieldAmulet\SpellShieldCaster.mdl]]

function mt:on_add()

    local hero = self.owner 
    local damage_base = self.damage_base 
    hero:add('魔法',hero:get('魔法上限'))

    self.trg = hero:event '受到伤害前效果' (function (_,damage)
        
        local value = hero:get('魔法') * damage_base
        if value > 0 then 

            local buf = hero:find_buff '魔法护盾效果'
            if buf == nil then 
                hero:add_buff '魔法护盾效果'
                {
                    source = damage.target,
                    time = 0.5,
                }
                for i=1,5 do 
                    local effect = ac.effect(hero:get_point(),self.model,i * 72,1,self.ref,hero:get_high())
                    effect:remove()
                end
            end

            value = damage:get_current_damage() - value
            hero:add('魔法',-damage:get_current_damage() / damage_base)
            if value > 0 then 
                --抵消一部分伤害
                damage:set_current_damage(value)
            else 
                --抵消所有伤害
                damage:div(1)
            end

        end
            
    end)


end


function mt:on_remove()
    if self.trg then 

        self.trg:remove()
        self.trg = nil

    end 
end

local mt = ac.buff['魔法护盾效果']
