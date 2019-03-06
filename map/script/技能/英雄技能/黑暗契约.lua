local mt = ac.skill['黑暗契约']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--冷却时间
	cool = 25,
	--伤害
	damage = 2,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_UNIT,
	--施法距离
	range = 500,
	--介绍
	tip = [[与黑暗签下契约，损失50% 当前生命值，对指定敌人进行一次吸魂，造成敏捷*10的法术伤害，该技能如果杀死敌人，英雄将永久提高 0.5% 的敏捷]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNDeathPact.blp]],
	--永久智力
	addagi = 0.5,
	--消耗生命
	cost_life = 50,
	--伤害
	damage = function(self,hero)
		if self and self.owner then 
		return self.owner:get('敏捷')*10
		end
	end	,
	damage_type = '法术'
}
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	local target = self.target
	-- print(target,target.data.type)
	hero:add('生命',-hero:get('生命')*self.cost_life/100)

	local ln = ac.lightning('LN00',hero,target,50,50)
	ln:fade(-5)
	
	target:damage
	{
		source = hero,
		damage = self.damage,
		skill = self,
		damage_type =self.damage_type
	}

	if not target:is_alive() then 
		hero:add('敏捷',math.ceil(hero:get('敏捷')*self.addagi/100))
	end	
end	
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end


