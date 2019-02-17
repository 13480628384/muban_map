local mt = ac.skill['魔霭诅咒']

mt.ref = 'origin'
mt.model = [[Abilities\Spells\Items\SpellShieldAmulet\SpellShieldCaster.mdl]]

function mt:on_add()

    local hero = self.owner 

    self.trg = hero:event '造成伤害开始' (function (_,damage)
        local target = damage.target 

        --if  target.unit_type ~= '英雄' then 
        --    return 
        --end 
        local buf = target:add_buff '魔霭诅咒减伤'
        {
            source = hero,
            rate = self.rate / 100,
            value = self.value,
            time = self.time,
            skill = self,
        }

        local count = 0
        for buff in target:each_buff('魔霭诅咒减伤') do 
            count = count + 1
        end 
        ac.texttag
        {
            string = '伤害削减 ' .. tostring(count * self.rate) .. '%',
            size = 10,
            position = target:get_point(),
            speed = 86,
            red = 20,
            green = 20,
            blue = 100,
            player = target:get_owner(),
            show = ac.texttag.SHOW_SELF
        }
        
    end)


end


function mt:on_remove()
    if self.trg then 

        self.trg:remove()
        self.trg = nil

    end 
end




local mt = ac.buff['魔霭诅咒减伤']

mt.cover_type = 1
mt.cover_max = 999

mt.control = 2
mt.debuff = true
mt.ref = 'overhead'
mt.model = [[Abilities\Spells\Other\FrostDamage\FrostDamage.mdl]]

function mt:on_add()
    local rate = self.rate 
    local hero = self.target
    self.effect = self.target:add_effect(self.ref, self.model)
    self.trg = hero:event '造成伤害前效果' (function (_,damage)
        local count = self:get_stack()
        if count > 0 then 
            damage:div(rate)
        end 
    end)


    self.trg2 = hero:event '单位-杀死单位' (function (_,killer,unit)
        if killer ~= hero then 
            return 
        end
        self.is_killer = true 
        self:remove()

    end)


end

function mt:on_remove()
    if not self.is_killer then 
        self.target:add('基础力量',-self.value)
        self.target:add('基础敏捷',-self.value)
        self.target:add('基础智力',-self.value)
    end 
   
    if self.trg then 
        self.effect:remove()
        self.trg:remove()
        self.trg2:remove()
        self.trg = nil
    end 
end


