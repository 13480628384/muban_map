local mt = ac.skill['长者']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "被动",
	--被动
	passive = true,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[召唤物属性+50%]],
	--技能图标
	art = [[jineng\jineng014.blp]],
	summon_attr = 50,
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('召唤物属性',self.summon_attr)
end
function mt:on_remove()
    local hero = self.owner
    hero:add('召唤物属性',-self.summon_attr)
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
