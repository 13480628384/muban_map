local mt = ac.skill['资源礼包']
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
    --开局金币
    add_gold = 1000,
    --每秒金币
    per_gold = 6,
	--金币加成
    gold_rate = 20,
    
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:addGold(self.add_gold)
    hero:add('每秒金币',self.per_gold)
    hero:add('金币加成',self.gold_rate)
  
    
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    
    hero:add('每秒金币',-self.per_gold)
    hero:add('金币加成',-self.gold_rate)
end
