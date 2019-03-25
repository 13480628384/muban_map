local mt = ac.skill['死亡之指']
mt{
    --必填
    is_skill = true,
    --初始等级
	level = 1,
	max_level = 5,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = {10,100,200,400,500},
	--冷却时间
	cool = 10,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_UNIT,
	--施法距离
	range = 800,
	--介绍
	tip = [[对指定敌人造成智力*%int%的法术伤害，该技能如果杀死敌人，将刷新冷却]],
	--技能图标
	art = [[jineng\jineng003.blp]],

	int = {12,24,36,48,60},

	--伤害
	damage = function(self,hero)
		if self and self.owner then 
			return self.owner:get('智力')*self.int
		end	
	end,
	--伤害类型
	damage_type = '法术'

}
function mt:on_add()
    local skill = self
    local hero = self.owner
end
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	local target = self.target

	local ln = ac.lightning('TWLN',hero,target,50,50)
	ln:fade(-5)
	
	target:damage
	{
		source = hero,
		damage = self.damage,
		skill = self,
		damage_type =self.damage_type
	}
	if not target:is_alive() then 
		self:set_cd(0)
		self:fresh()
	end	
end	
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
