local mt = ac.skill['穿刺']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = 30,
	--冷却时间20
	cool = 20,
	--伤害
	damage = 6,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_POINT,
	--施法距离
	range = 800,
	--介绍
	tip = [[对一条直线上的敌人晕眩1S，并造成力量*6的法术伤害 （%damage%） ]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNImpale.blp]],
	--特效
	effect = [[Abilities\Spells\Undead\Impale\ImpaleHitTarget.mdx]],
	--特效1
	effect1 = [[Abilities\Spells\Undead\Impale\ImpaleMissTarget.mdx]],
	--伤害
	damage = function(self,hero)
		if self and self.owner then 
		return self.owner:get('力量') * 6
		end
	end,
	--持续时间
	time = 3 ,
	--碰撞范围
	hit_area = 200,
	--特效移动速度
	speed = 5000,
}
function mt:on_add()
    local skill = self
    local hero = self.owner
end


function mt:on_cast_shot()
    local skill = self
    local hero = self.owner

	local source = hero:get_point()
	local target = self.target:get_point()
	local angle = source / target
	-- print('打印 施法出手',angle)
	-- hero:add_effect('origin',self.effect):remove()
	local mvr = ac.mover.line
	{
		source = hero,
		start = hero,
		angle = angle,
		speed = skill.speed,
		distance = skill.range,
		skill = skill,
		high = 110,
		model = '', 
		hit_area = skill.hit_area,
		size = 1
	}
	if not mvr then 
		return
	end

	function mvr:on_move()
		-- print('移动中创建特效',skill.effect1)
		ac.effect(self.mover:get_point(),skill.effect1,0,1,'origin'):remove()  
	end	
	function mvr:on_hit(dest)
		for i, u in ac.selector()
			: in_range(dest,skill.hit_area)
			: is_enemy(hero)
			: of_not_building()
			: ipairs()
		do
			
			u:add_effect('origin',skill.effect):remove()
			u:add_buff '晕眩'
			{
				time = skill.time,
				skill = skill,
				source = hero,
			}
			
			u:add_buff '高度'
			{
				time = 0.3,
				speed = 1200,
				skill = skill,
				reduction_when_remove = true
			}
			u:damage
			{
				skill = skill,
				source = hero,
				damage = skill.damage,
				damage_type = '法术'
			}
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

