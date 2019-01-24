local mt = ac.buff['buff-吸血光环']

mt.cover_type = 1
mt.cover_max = 20

mt.pulse = 1
mt.effect_cover = 1 
mt.effect_data = {
    ['origin'] = [[Abilities\Spells\Other\GeneralAuraTarget\GeneralAuraTarget.mdl]]
}

function mt:on_add()
	local hero = self.target
    hero:add('吸血',self.value)
end

function mt:on_remove()
    local hero = self.target
    hero:add('吸血',-self.value)
end

