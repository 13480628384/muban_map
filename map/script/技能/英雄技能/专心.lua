local mt = ac.skill['专心']
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
	tip = [[物品获取率+50%]],
	--技能图标
	art = [[jineng\jineng017.blp]],
	item_rate = 50,
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('物品获取率',self.item_rate)
end
function mt:on_remove()
    local hero = self.owner
    hero:add('物品获取率',-self.item_rate)
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
