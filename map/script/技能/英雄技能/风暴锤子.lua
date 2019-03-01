local mt = ac.skill['风暴锤子']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = 30,
	--冷却时间
	cool = 20,
	--伤害
	damage = 12,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_UNIT,
	--施法距离
	range = 900,
	--介绍
	tip = [[对单一敌人造成晕眩3S，并造成攻击力*3的法术伤害]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNStormBolt.blp]],
	--特效
	effect = [[StormBoltMissile.mdx]],
	--特效
	effect1 = [[StormBoltTarget.mdx]],
	--持续时间
	time = 3,
	--伤害
	damage = function(self,hero)
		return self.owner:get('攻击')*3
	end	,
	--投射物移动速度
	speed = 1000,
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
end

function mt:on_cast_shot()
    local skill = self
    local hero = self.owner

	local target = self.target
	-- print('弹射目标：',u,u:get_point())
	local mvr = ac.mover.target
	{
		source = hero,
		target = target,
		speed = skill.speed,
		skill = skill,
		high = 110,
		model = skill.effect, 
		size = 1
	}
	if not mvr then 
		return
	end

	function mvr:on_finish()
		target:add_buff '晕眩'
		{
			source = hero,
			skill = skill,
			time = skill.time
			
		}
		target:damage
		{
			skill = skill,
			source = hero,
			damage = skill.damage,
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
