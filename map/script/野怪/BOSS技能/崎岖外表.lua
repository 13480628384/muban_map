
local mt = ac.skill['崎岖外表']
mt.model = [[Abilities\Weapons\RockBoltMissile\RockBoltMissile.mdl]]

function mt:on_add()
    local hero = self.owner
    local skill = self
    local damage_data = skill:damage_data_cal()
    self.trg = hero:event '单位-被攻击开始' (function(_,damage)
        local source = damage.source
        if math.random(0,99) < skill.chance then
            source:add_buff '晕眩'
            {
                skill = skill,
                time = skill.stun,
                source = hero,   
            }
            skill:damage
            {
                source = hero,
                target = source,
                damage = damage_data.damage,
                damage_type = damage_data.damage_type,
            }
            source:add_effect('chest',skill.model):remove()
        end
    end)
end

function mt:on_remove()
    if self.trg then
        self.trg:remove()
    end
end
