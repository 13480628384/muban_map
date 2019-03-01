local mt = ac.skill['痛苦尖叫']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = 15,
	--冷却时间10
	cool = 1,
	--伤害
	damage = 5,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--施法范围
	area = 600,
	--介绍
	tip = [[发出锐利的尖叫，对范围300码的敌方单位造成智力*4法术伤害 （%damage%） ]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNPossession.blp]],
	--特效
	effect = [[Abilities\Spells\Undead\Possession\PossessionMissile.mdl]],
	--伤害参数1
	int = {4,8,10},
	--伤害
	damage = function(self,hero)
		return self.owner:get('智力')*self.int
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
		: is_enemy(hero)
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
			u:damage
			{
				source = hero,
				damage = skill.damage ,
				skill = skill,
				damage_type =skill.damage_type
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
