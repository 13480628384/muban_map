local mt = ac.skill['刀刃旋风']
mt{
    --必填
    is_skill = true,
    --初始等级
	level = 1,
	max_level = 5,
	--技能类型
	skill_type = "主动 敏捷",
	--耗蓝
	cost = {20,130,240,350,460},
	--冷却时间 15
	cool = 5,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--施法范围
	area = 800,
	--介绍
	tip = [[|cff11ccff%skill_type%:|r 召唤刀刃对范围800码的敌方单位造成物理伤害
	伤害计算：|cffd10c44敏捷 * %int%|r+ |cffd10c44 %shanghai% |r
	伤害类型：|cff04be12物理伤害|r
	]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNFanOfKnives.blp]],
	--特效
	effect = [[Abilities\Spells\NightElf\FanOfKnives\FanOfKnivesMissile.mdl]],
	--伤害参数1
	int = {20,25,30,35,40},

	shanghai ={20000,200000,2000000,5000000,8000000},

	--伤害
	damage = function(self,hero)
		if self and self.owner and self.owner:is_hero() then 
			return self.owner:get('敏捷')*self.int+self.shanghai
		end
	end	,
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
	local angle_base = 0
	local num = 3
	for i = 1, num do
		local mvr = ac.mover.line
		{
			source = hero,
			skill = skill,
			start = hero:get_point(),
			model =  skill.effect,
			speed = 800,
			angle = angle_base + 360/num * i,
			distance = skill.area  ,
			size = 2,
			height = 120
		}
		if not mvr then
			return
		end
	end	

	for i, u in ac.selector()
	: in_range(hero,self.area)
	: is_enemy(hero)
	: of_not_building()
	: ipairs()
	do
		u:damage
		{
			source = hero,
			damage = skill.damage ,
			skill = skill,
			damage_type =skill.damage_type
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
