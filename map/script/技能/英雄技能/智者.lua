local mt = ac.skill['智者']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "被动",
	--被动
	passive = true,
	--伤害
	damage = 1.15,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[法术伤害+15%]],
	--技能图标
	art = [[jineng\jineng018.blp]],
	--法术伤害
	magic_damage = 15,
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('法术攻击',self.magic_damage)
end
function mt:on_remove()
    local hero = self.owner
    hero:add('法术攻击',-self.magic_damage)
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
