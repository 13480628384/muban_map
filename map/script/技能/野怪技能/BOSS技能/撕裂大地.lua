local mt = ac.skill['撕裂大地']
mt{--目标类型 = 单位
target_type = ac.skill.TARGET_TYPE_POINT,
--施法信息
cast_start_time = 0,
cast_channel_time = 1.5,
cast_shot_time = 0,
cast_finish_time = 1,
--初始等级
level = 1,
--技能图标
art = [[icon\card\2\card2_3.blp]],
--技能说明
title = '撕裂大地',
tip = [[
    撕裂大地
]],
--消耗
cost_data = {	type = '魔法',	num_type = '三维',	rate = 0.2,},
--范围
range = 1000,
area = 500,
--致盲
stun = 2,
--冷却
cool = 3}
mt.effect = [[Abilities\Spells\Other\Volcano\VolcanoDeath.mdl]]
mt.effect2 = [[Abilities\Spells\Orc\EarthQuake\EarthQuakeTarget.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local target = self.target
    local skill = self
    -- local damage_data = skill:damage_data_cal()
    ac.effect_ex
    {
        point = target,
        model = skill.effect,
        size = 2.5,
    }:remove()
    ac.effect_ex
    {
        point = target,
        model = skill.effect2,
        size = 2,
        time = 1,
    }:remove()   
    for _,u in ac.selector()
        : in_range(target,skill.area)
        : is_enemy(hero)
        : ipairs()
    do
        u:add_buff '晕眩'
        {
            skill = skill,
            source = hero,
            time = skill.stun,
        }
        u:damage
        {
            source = hero,
            skill = self,
            damage = hero:get('攻击')*10
        }
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
end