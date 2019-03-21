local mt = ac.skill['生存会员']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNFlakCannons.blp]],
	--特效
	effect = [[]],
	--物品获取率
	fall_rate = 10,
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('物品获取率',self.fall_rate)
    --添加称号
    self.trg = hero:add_effect('chest',self.effect)
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    
    hero:add('物品获取率',-self.fall_rate)
end
