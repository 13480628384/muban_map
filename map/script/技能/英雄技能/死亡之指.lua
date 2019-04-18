local mt = ac.skill['死亡之指']
mt{
    --必填
    is_skill = true,
    --初始等级
	level = 1,
	max_level = 5,
	--技能类型
	skill_type = "主动 智力",
	--耗蓝
	cost = {10,100,200,400,500},
	--冷却时间
	cool = 10,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_UNIT,
	--施法距离
	range = 800,
	--介绍
	tip = [[|cff11ccff%skill_type%:|r 对指定敌人造成法术伤害，该技能如果杀死敌人，将刷新冷却
	伤害计算：|cffd10c44 智力 * %int% + |cffd10c44 %shanghai% |r
	伤害类型：|cff04be12法术伤害|r
	]],
	--技能图标
	art = [[jineng\jineng003.blp]],

	int = {25,30,35,40,50},

	shanghai ={25000,250000,2500000,6250000,10000000},

	--伤害
	damage = function(self,hero)
		if self and self.owner and self.owner:is_hero() then 
			return self.owner:get('智力')*self.int+self.shanghai
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
		-- self:fresh()
	end	
end	
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
