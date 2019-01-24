local mt = ac.skill['雷击']
mt.effect = [[Abilities\Spells\Other\Monsoon\MonsoonBoltTarget.mdl]]
mt.effect2 = [[Abilities\Spells\Human\Thunderclap\ThunderClapCaster.mdl]]
mt.effect3 = [[Abilities\Weapons\ChimaeraLightningMissile\ChimaeraLightningMissile.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local target = self.target
    local damage_data = skill:damage_data_cal()

    ac.effect_ex
    {
        point = target,
        model =  skill.effect,
        size = 2,
    }:remove()
    ac.effect_ex
    {
        point = target,
        model =  skill.effect2,
        size = skill.area/200,
    }:remove()

    for _,u in ac.selector()
        : in_range(target,skill.area)
        : is_enemy(hero)
        : ipairs()
    do
        skill:damage
        {
            source = hero,
            target = u,
            damage = damage_data.damage,
            damage_type =damage_data.damage_type,
        }
        u:add_effect('chest',skill.effect3):remove()
        --[[ u:add_buff '击退'
        {
            source = hero,
            high = 600,
            distance = 100,
            time = 2,
            angle = target:get_point() / u:get_point(),
        } ]]
    end

end

function mt:on_cast_start()
    self.eft = ac.warning_effect_ring
    {
        point = self.target,
        area = self.area,
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
end

function mt:on_remove()
end--[[  ]]