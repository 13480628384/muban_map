local mt = ac.skill['践踏']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = 40,
	--冷却时间
	cool = 25,
	--伤害
	damage = 5,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--施法范围
	area = 500,
	--介绍
	tip = [[对范围500码敌人晕眩2S，并造成力量*5的物理伤害 （%damage%） ]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNWarStomp.blp]],
	--特效
	effect = [[Abilities\Spells\Human\ThunderClap\ThunderclapCaster.mdx]],
	--特效1
	effect1 = [[Abilities\Spells\Human\ThunderClap\ThunderclapTarget.mdx]],
	--伤害
	damage = function(self,hero)
		if self and self.owner then 
		return self.owner:get('力量') * 5
		end
	end,
	--持续时间
	time = 2 ,
}

function mt:on_add()
    local skill = self
    local hero = self.owner
end


function mt:on_cast_shot()
    local skill = self
    local hero = self.owner

    local point = hero:get_point()
	-- hero:add_effect('origin',self.effect):remove()
	local effect = ac.effect(point,self.effect,0,2,'origin'):remove()

	for i, u in ac.selector()
		: in_range(hero,self.area)
		: is_enemy(hero)
		: of_not_building()
		: ipairs()
	do
		u:add_buff '晕眩'
		{
			time = self.time,
			skill = self,
			source = hero,
			model = self.effect1,
		}
		u:damage
		{
			skill = self,
			source = hero,
			damage = self.damage,
			damage_type = '物理'
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
