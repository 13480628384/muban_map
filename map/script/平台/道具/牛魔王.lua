local japi = require("jass.japi")
local mt = ac.skill['牛魔王']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[所有敌人的护甲-25%（可与魔王降临光环叠加）]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNFlakCannons.blp]],
	--特效
	effect = [[HeroTaurenChieftain.mdx]],
	--护甲值
	value = 25,
	--物爆伤害
    physical_damage = 50,
    --影响范围
    area = 99999,
	--特效
	source_effect = [[Abilities\Spells\Undead\RegenerationAura\ObsidianRegenAura.mdl]],
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    --改变模型
    japi.SetUnitModel(hero.handle,self.effect)

    self.buff = hero:add_buff '牛魔王'
    {
        source = hero,
        skill = self,
        selector = ac.selector()
            : in_range(hero, self.area)
            : is_enemy(hero)
            ,
        -- buff的数据，会在所有自己的子buff里共享这个数据表
        data = {
            value = self.value,
            source_effect = self.source_effect,
        },
    }
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    if self.buff then
        self.buff:remove()
        self.buff = nil
    end
    
end

local mt = ac.aura_buff['牛魔王']
-- 魔兽中两个不同的专注光环会相互覆盖，但光环模版默认是不同来源的光环不会相互覆盖，所以要将这个buff改为全局buff。
mt.cover_global = 1
mt.cover_type = 1
mt.cover_max = 1
mt.effect = [[]]
mt.keep = true


function mt:on_add()
    local target = self.target
    -- print('打印受光环英雄的单位',self.target:get_name())
    if self.target ==  self.source then 
        self.source_eff = self.target:add_effect('origin', self.data.source_effect)
    else
        -- self.target_eff = self.target:add_effect('origin', self.data.target_effect)
        target:add('护甲%',-self.data.value)
    end  
    
end

function mt:on_remove()
    local target = self.target
    if self.source_eff then self.source_eff:remove() end
    if self.target_eff then self.target_eff:remove() end
    
    target:add('护甲%',self.data.value)
end
