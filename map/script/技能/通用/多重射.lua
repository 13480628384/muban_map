

local self = {}
local function range_attack_start(hero,damage)

    -- print('打印改变攻击方式')
    if damage.skill and damage.skill.name == self.name then
        return
    end
    local target = damage.target
    local hero = damage.source
    local damage = damage.damage
    local count = hero:get('多重射') + 1 

	local speed = hero.missile_speed or (hero.weapon and hero.weapon['弹道速度']) or hero:get_slk('Missilespeed_1', 0)
	local arc =  hero:get_slk('Missilearc_1', 0)
    local model = hero.missile_art or (hero.weapon and hero.weapon['弹道模型']) or hero:get_slk 'Missileart_1'
    local unit_mark = {}
     
    for i,u in ac.selector()
        : in_range(hero,hero:get('攻击距离'))
        : is_enemy(hero)
        : of_not_building()
        : sort_nearest_hero(hero) --优先选择距离英雄最近的敌人。
        : set_sort_first(target)
        : ipairs()
    do
        if i <= count then
            local mvr = ac.mover.target
            {
                source = hero,
                target = u,
                path = true,
                model = model,
                speed = speed,
                damage = damage,
                height = hero:get_point() * u:get_point() * arc,
                skill = false,
            }
            if not mvr then
                return
            end
            function mvr:on_finish()
                u:damage
                {
                    source = hero,
                    damage = damage,
                    skill = false,
                    missile = self.mover
                }
            end
            

        end	
    end
    hero.range_attack_start = self.oldfunc

end



ac.game:event '单位-攻击出手' (function(trg, damage)
    if not damage.source:is_type('英雄') then 
        return
    end        
    -- if math.random(1,100) > self.chance then
    --     return
    -- end
    local hero = damage.source
    -- print('打印攻击出手',hero:isMelee())
    self.oldfunc = hero.range_attack_start
    hero.range_attack_start = range_attack_start
    return false
end)
