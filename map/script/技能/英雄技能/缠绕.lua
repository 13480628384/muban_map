local mt = ac.skill['缠绕']
mt{
    --必填
    is_skill = true,
    --初始等级
	level = 1,
	max_level = 5,
	--技能类型
	skill_type = "主动 智力 控制",
	--耗蓝
	cost = {30,150,270,400,500},
	--冷却时间
	cool = {10},
	--技能目标
	target_type = ac.skill.TARGET_TYPE_POINT,
	--施法距离
	range = 800,
	--施法范围
	area = 300,
	--介绍
	tip = [[|cff11ccff%skill_type%:|r 用树藤缠住目标区域敌人的脚，造成敌人不能行动1S，并造成攻击力*1.5的法术伤害
	]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNEntanglingRoots.blp]],
	--特效
	effect = [[Abilities\Spells\NightElf\EntanglingRoots\EntanglingRootsTarget.mdl]],
	--持续时间
	time = 1 ,
	int = {10,20,30,40,50},
	--伤害
	damage = function(self,hero)
		if self and self.owner then 
		return self.owner:get('攻击') * self.int
		end
	end
}
function mt:on_add()
    local skill = self
    local hero = self.owner
end
function mt:on_cast_shot()
    local skill = self
    local hero = self.owner

	local target = self.target

	for i, u in ac.selector()
		: in_range(target,self.area)
		: is_enemy(hero)
		: of_not_building()
		: ipairs()
	do
		u:add_buff '定身'
		{
			time = self.time,
			skill = self,
			source = hero,
			model = self.effect,
		}
		u:damage
		{
			skill = self,
			source = hero,
			damage = self.damage,
			damage_type = '法术'
		}
	end	
	
end	
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
