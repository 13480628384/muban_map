local mt = ac.skill['吸血光环']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
    max_level = 5,
	--技能类型
	skill_type = "光环",
	--被动
	passive = true,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
    tip = [[|cff11ccff%skill_type%:|r 周围的单位能将他们自己对敌人的伤害值%value% %转化成自己的生命值
    ]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNVampiricAura.blp]],
	--特效
	effect = [[Abilities\Spells\Undead\VampiricAura\VampiricAura.mdl]],
    --光环影响范围
    area = 99999,
    --值
    value = {0.2,0.4,0.6,0.8,1},
}
function mt:on_upgrade()
    local skill = self
    local hero = self.owner

    self.buff = hero:add_buff '吸血光环'
    {
        source = hero,
        skill = self,
        target_effect = self.effect,
        selector = ac.selector()
            : in_range(hero, self.area)
            : is_ally(hero)
            ,
        -- buff的数据，会在所有自己的子buff里共享这个数据表
        data = {
            value = self.value,
            target_effect = self.effect,
        },
    }
 
end
function mt:on_remove()
    local hero = self.owner
    if self.buff then
        self.buff:remove()
        self.buff = nil
    end
end

local mt = ac.aura_buff['吸血光环']
-- 魔兽中两个不同的专注光环会相互覆盖，但光环模版默认是不同来源的光环不会相互覆盖，所以要将这个buff改为全局buff。
mt.cover_global = 1
mt.cover_type = 1
mt.cover_max = 1
mt.effect = [[]]
mt.keep = true


function mt:on_add()
    local target = self.target
    -- print('打印受光环英雄的单位',self.target:get_name())
    self.target_eff = self.target:add_effect('origin', self.data.target_effect)
    target:add('吸血',self.data.value)

end

function mt:on_remove()
    local target = self.target
    if self.source_eff then self.source_eff:remove() end
    if self.target_eff then self.target_eff:remove() end
    
    target:add('吸血',-self.data.value)
end
