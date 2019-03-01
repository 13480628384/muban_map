local mt = ac.skill['弹射']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--生成文件
	ignore_file = "string",
	--技能类型
	skill_type = "被动",
	--被动
	passive = true,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[攻击力-20%，可以攻击多个目标，从第二个开始，每次弹射，目标所受伤害衰减30%，弹射5个]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNUpgradeMoonGlaive.blp]],
	--特效1
	effect1 = [[Hero_EmberSpirit_N2S_C_Effect.mdx]],
	--弹射目标
	cnt = 5,
	--每次递减
	reduce = 30,
	--攻击减少
	attack = 20,

	--弹射目标
	current_cnt = 0,

	--弹射速度
	speed = 800,
}
function mt:on_add()
    local skill = self
    local hero = self.owner
	hero:add('攻击%',-self.attack)

	self.trg = hero:event '造成伤害效果' (function (trg,damage) 
		-- self = self:create_cast()
		self.current_cnt = self.current_cnt + 1
		-- print('弹射：',self.current_cnt)
		if self.current_cnt >= self.cnt then 
			self.current_cnt = 0
			return 	
		end	 

		local target = damage.target
		-- print('弹射起始位置：',target,target:get_point())
		local u = ac.selector():in_range(target,700):is_enemy(hero):is_not(target):random()
		if not u then 
			return 
		end	
		-- print('弹射目标：',u,u:get_point())
		local mvr = ac.mover.target
		{
			source = hero,
			start = target,
			target = u,
			speed = skill.speed,
			skill = skill,
			high = 110,
			model = skill.effect1, 
			size = 1
		}
		if not mvr then 
			return
		end

		function mvr:on_finish()
			u:damage
			{
				source = hero,
				skill = skill,
				damage = damage.damage * (1 - skill.reduce/100)
			}
		end	
	end)
	
end
function mt:on_remove()
    local hero = self.owner
    hero:add('攻击%',self.attack)
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end
