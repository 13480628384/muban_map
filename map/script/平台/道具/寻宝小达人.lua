local mt = ac.skill['寻宝小达人']
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
    --藏宝图数量
    cbt_cnt = 5,
    --移动速度
    move_speed = 50,
	--物品获取率
    fall_rate = 20,
    
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('物品获取率',self.fall_rate)
    hero:add('移动速度',self.move_speed)
    for i =1 ,self.cbt_cnt do 
        hero:add_item('藏宝图',true)
    end    
    hero:add_restriction '幽灵'
    
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    
    hero:add('物品获取率',-self.fall_rate)
    hero:add('移动速度',-self.move_speed)
    hero:remove_restriction '幽灵'
end
