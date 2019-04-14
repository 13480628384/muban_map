local japi = require("jass.japi")
local mt = ac.skill['王昭君']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[移速+50，技能冷却减少15%]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNFlakCannons.blp]],
	--特效
	effect = [[Hero_CrystalMaiden_N2.mdx]],
	--移动速度
	move_speed = 50,
	--冷却缩减
	cool_reduce = 15,
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('移动速度',self.move_speed)
    hero:add('冷却缩减',-self.cool_reduce)
    --改变模型
    japi.SetUnitModel(hero.handle,self.effect)
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    
    hero:add('移动速度',-self.move_speed)
    hero:add('冷却缩减',self.cool_reduce)
end
