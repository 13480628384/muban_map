local mt = ac.skill['恶魔翅膀']
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
	effect = [[units\human\Gyrocopter\Gyrocopter.mdl]],
	--移动速度
	move_speed = 50,
	--攻击速度
	attack_speed = 50,
	--金币加成
	gold_mul = 5,
	--经验加成
    exp_mul = 5,
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('金币加成',self.gold_mul)
    hero:add('经验加成',self.exp_mul)
    hero:add('移动速度',self.move_speed)
    hero:add('攻击速度',self.attack_speed)
    --添加翅膀
    self.trg = hero:add_effect('chest',self.effect)
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    
    hero:add('金币加成',-self.gold_mul)
    hero:add('经验加成',-self.exp_mul)
    hero:add('移动速度',-self.move_speed)
    hero:add('攻击速度',-self.attack_speed)
end
