local mt = ac.skill['光明契约']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = function(self,hero)
		return hero:get('魔法')
	end	,
	--冷却时间25
	cool = 1,
	--伤害
	damage = 2,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_UNIT,
	--施法距离
	range = 500,
	--介绍
	tip = [[耗尽自己全部魔法值，对指定敌人进行一次吸精，造成智力*2的法术伤害，该技能如果杀死敌人，英雄将永久提高0.5%的智力]],
	--技能图标 LNXQ
	art = [[jineng\jineng026.blp]],
	--永久智力
	addint = 0.5,
	--伤害
	damage = function(self,hero)
		if self and self.owner then 
			return self.owner:get('智力')*2
		end	
	end	,
	damage_type = '法术'
}
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	local target = self.target
	-- print(target,target.data.type)

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
		hero:add('智力',math.ceil(hero:get('智力')*self.addint/100))
	end	
end	
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end

