

local self = {}
local function range_attack_start(hero,damage)
    -- print('英雄 重新进行攻击')
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
        : in_range(hero,hero:get('攻击距离')+100) -- +100 避免怪物逃跑时超出攻击距离而选不到人
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
                height = 110,
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
                    missile = self.mover,
                    attack = true,
                    common_attack = true,
                }
            end
            

        end	
    end
    -- hero.range_attack_start = self.oldfunc

end



ac.game:event '单位-发动攻击'  (function(trg, damage)
    if not damage.source:is_type('英雄') or damage.source:isMelee()  then 
        return
    end     
      
    -- if math.random(1,100) > self.chance then
    --     return
    -- end
    local hero = damage.source
    range_attack_start(hero,damage)
    return true
end)
