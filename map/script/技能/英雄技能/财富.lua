local mt = ac.skill['财富']
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
	tip = [[金钱获取率+50%]],
	--技能图标
	art = [[jineng\jineng019.blp]],
	more_gold = 50,
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('金币加成',self.more_gold)
end
function mt:on_remove()
    local hero = self.owner
    hero:add('金币加成',-self.more_gold)
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
