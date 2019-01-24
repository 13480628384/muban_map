local mt = ac.buff['buff-恢复光环']

mt.cover_type = 1
mt.cover_max = 20

mt.pulse = 1
mt.effect_cover = 1 
mt.effect_data = {
    ['origin'] = [[Abilities\Spells\Other\GeneralAuraTarget\GeneralAuraTarget.mdl]]
}

function mt:on_add()
    local hero = self.target
    hero:add('生命',hero:get('生命上限') * self.value / 100)
end

function mt:on_remove()

end

