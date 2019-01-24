local mt = ac.buff['buff-命令光环']

mt.cover_type = 1
mt.cover_max = 20

mt.pulse = 1
mt.effect_cover = 1 
mt.effect_data = {
    ['origin'] = [[Abilities\Spells\Other\GeneralAuraTarget\GeneralAuraTarget.mdl]]
}

function mt:on_add()
    local hero = self.target
    self.state = hero:get('基础攻击') * (self.value / 100)
    hero:add('额外攻击',self.state)
end

function mt:on_remove()
    local hero = self.target
    hero:add('额外攻击',-self.state)
end

