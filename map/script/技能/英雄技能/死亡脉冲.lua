local mt = ac.skill['死亡脉冲']
mt{
    --必填
    is_skill = true,
    --初始等级
	level = 1,
	max_level = 5,
	--技能类型
	skill_type = "主动 智力 治疗",
	--耗蓝
	cost = {15,115,215,315,415},
	--冷却时间10
	cool = 10,

	--技能无目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--施法范围
	area = 800,

	--介绍
	tip = [[对范围800码的敌方单位造成 智力*%int% 法术伤害（%damage%）
	对范围400码的友方单位有智力*%int%医疗效果 （%heal%）
	]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNDeathCoil.blp]],
	--特效
	effect = [[Abilities\Spells\Undead\DeathCoil\DeathCoilMissile.mdl]],

	int = {4,5,6,7,8},

	--治疗
	heal = function(self,hero)
		if self and self.owner then 
			return self.owner:get('智力')*self.int
		end	
	end	,
	--伤害
	damage = function(self,hero)
		if self and self.owner then 
			return self.owner:get('智力')*self.int
		end
	end	,
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
	for i, u in ac.selector()
		: in_range(hero,self.area)
		: of_not_building()
		: ipairs()
	do
		local mvr = ac.mover.target
		{
			source = hero,
			target = u,
			model = skill.effect,
			speed = 600,
			height = 110,
			skill = skill,
		}
		if not mvr then
			return
		end
		function mvr:on_finish()
			if u:is_enemy(hero) then 
				u:damage
				{
					source = hero,
					damage = skill.damage ,
					skill = skill,
					damage_type =skill.damage_type
				}	
			else
				u:heal
				{
					source = hero,
					skill = skill,
					size = 10,
					heal = skill.heal,
				}	
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
