local mt = ac.skill['神威']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		主动：将变大的武器直插入地，对周围 %area% 码的敌人造成 攻击力*2+敏捷*3 的物理伤害( %damage% ),将其晕眩 %time% 秒 
		被动：+%physical_crite_rate% % 会心几率
	]],
	
	--技能图标
	art = [[jineng\jineng006.blp]],

	--技能目标类型 无目标
	target_type = ac.skill.TARGET_TYPE_NONE,

	--施法范围
	area = 600,

	--持续时间
	time = 2,

	--伤害
	damage = function(self,hero)
		return hero:get('攻击')*2 + hero:get('敏捷')*3
	end,	

	--护甲
	physical_crite_rate = 20,

	--cd 20
	cool = 20,

	--耗蓝 30
	cost = 30,

	--特效模型
	effect = [[AZ_Kaer_T1.mdx]],
	-- effect = [[Hero_Juggernaut_N4S_F_Source.mdx]],
	
}


function mt:on_add()
	local hero = self.owner 
	hero:add('会心几率',self.physical_crite_rate)

end	
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner

	self.eff = ac.effect(hero:get_point(), self.effect, 270, 1.25,'origin'):remove()
	-- 
	for i, u in ac.selector()
		: in_range(hero,self.area)
		: is_enemy(hero)
		: of_not_building()
		: ipairs()
	do
		u:add_buff '晕眩'
		{
			source = hero,
			time = self.time,
		}
		u:damage
		{
			source = hero,
			damage = self.damage,
			skill = self
		}
	end	

end

function mt:on_remove()

    local hero = self.owner 
	hero:add('会心几率',-self.physical_crite_rate)
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end    

end
