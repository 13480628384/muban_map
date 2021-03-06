local japi = require("jass.japi")
local mt = ac.skill['大天使加百列']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[攻击+50%， 会心几率+10% ， 通关积分+50%]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNFlakCannons.blp]],
	--特效
    effect = [[ArchAngelngelGabriel.mdx]],
    --模型大小
	model_size = 1.3,
	--攻击
	attack_rate = 50,
	--会心几率
	heart_rate = 10,
    --获得积分额外倍数
    jifen_mul = 0.5
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    if not hero:is_hero() then return end
    if hero.name ~='鲁大师' then return end 
    hero:add('攻击%',self.attack_rate)
    hero:add('会心几率',self.heart_rate)
    hero:add('积分加成',self.jifen_mul)
    --改变模型
    japi.SetUnitModel(hero.handle,self.effect)
    hero:set_size(self.model_size)
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    
    hero:add('攻击%',-self.attack_rate)
    hero:add('会心几率',-self.heart_rate)
    hero:add('积分加成',-self.jifen_mul)
end
