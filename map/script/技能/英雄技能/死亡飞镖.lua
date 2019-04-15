local mt = ac.skill['死亡飞镖']
mt{
    --必填
    is_skill = true,
    --初始等级
	level = 1,
	max_level = 5,
	--技能类型
	skill_type = "主动 敏捷",
	--耗蓝
	cost = {10,110,210,310,400},
	--冷却时间8
	cool = 8,
	--伤害
	agi = {12,24,36,48,60},
	--技能目标
	target_type = ac.skill.TARGET_TYPE_UNIT,
	--施法距离
	range = 800,
	--介绍
	tip = [[|cff11ccff%skill_type%:|r 对指定敌人造成敏捷*%agi%的物理伤害，该技能如果杀死敌人，将刷新冷却
	]],
	--技能图标
	art = [[jineng\jineng028.blp]],
	--特效
	effect = [[Abilities\Weapons\SentinelMissile\SentinelMissile.mdl]],
	--伤害
	damage = function(self,hero)
		if self and self.owner and self.owner:is_hero() then 
			return self.owner:get('敏捷')*self.agi
		end	
	end,
	--伤害类型
	damage_type = '物理'

}
function mt:on_add()
    local skill = self
    local hero = self.owner
end
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	local target = self.target
	local mvr = ac.mover.target
	{
		source = hero,
		target = target,
		model = skill.effect,
		speed = 1200,
		height = 110,
		skill = skill,
	}
	if not mvr then
		return
	end
	function mvr:on_finish()
		if target:is_enemy(hero) then 
			target:damage
			{
				source = hero,
				damage = skill.damage ,
				skill = skill,
				damage_type =skill.damage_type
			}	
			if not target:is_alive() then 
				skill:set_cd(0)
				-- skill:fresh()
			end	
		end	
	end


end	
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
