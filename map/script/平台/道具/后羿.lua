local japi = require("jass.japi")
local mt = ac.skill['后羿']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[移速+50，攻击间隔减少0.05]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNFlakCannons.blp]],
	--特效
	effect = [[Hero_WindRunner_N2.mdx]],
	--移动速度
	move_speed = 50,
	--攻击间隔
	attack_gap = 0.05,
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('移动速度',self.move_speed)
    hero:add('攻击间隔',-self.attack_gap)
    --改变模型
    dzapi.DzSetUnitModel(hero.handle,self.effect)
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    hero:add('移动速度',-self.move_speed)
    hero:add('攻击间隔',self.attack_gap)
end
