local mt = ac.skill['血之祭祀']
mt.effect = [[Abilities\Spells\Undead\VampiricAura\VampiricAura.mdl]]
mt.effect2 = [[Objects\Spawnmodels\Critters\Albatross\CritterBloodAlbatross.mdl]]
mt.effect3 = [[war3mapimported\leoricvampiricaura.mdl]]
function mt:on_add()
end

function mt:on_remove()
end

function mt:boss_skill_shot()
    local hero = self.owner
    local target = self.target
    local skill = self
    local damage_data = skill:damage_data_cal()
    ac.effect_ex
    {
        point = target,
        model = skill.effect2,
        size = 2.5,
    }:remove()
    for _,u in ac.selector()
        : in_range(target,skill.area)
        : is_enemy(hero)
        : ipairs()
    do
        u:add_buff '沉默'
        {
            skill = skill,
            source = hero,
            time = skill.time,
        }
        skill:damage
        {
            source = hero,
            target = u,
            damage = damage_data.damage,
            damage_type = damage_data.damage_type,
        }
        u:add_effect('chest',skill.effect2):remove()
    end
end

function mt:on_cast_start()
    self.eft = ac.warning_effect_ring
    {
        point = self.target,
        area = self.area,
        time = self.cast_channel_time,
    }
    self.eft2 = ac.effect_ex
    {
        model = self.effect3,
        point = self.target,
        size = self.area/80,
        time = self.cast_channel_time,
    }
end

function mt:on_cast_shot()
    self:boss_skill_shot()
end

function mt:on_cast_stop()
    if self.eft then
        self.eft:remove()
    end
    if self.eft2 then
        self.eft2:remove()
    end
end

function mt:on_remove()
end