local mt = ac.skill['暴击']

mt{
	--必填
	is_skill = true,

	--技能类型
	skill_type = "被动",

	--是否被动
	passive = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		|cff00ccff被动|r:
		物爆几率+10% ，物爆伤害+50% 
		会心几率+10% ，会心伤害+50% 
		法爆几率+10% ，法爆伤害+50% 
	]],
	
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNCriticalStrike.blp]],

	--物爆
	physical_rate = 10,
	physical_damage = 50,
	--会爆
	heart_rate = 10,
	heart_damage = 50,
	--法爆
	magic_rate = 10,
	magic_damage = 50,


}


function mt:on_add()
	local skill = self
	local hero = self.owner 

	hero:add('物爆几率',self.physical_rate)
	hero:add('物爆伤害',self.physical_damage)
	hero:add('会心几率',self.heart_rate)
	hero:add('会心伤害',self.heart_damage)
	hero:add('法爆几率',self.magic_rate)
	hero:add('法爆伤害',self.magic_damage)

end	

function mt:on_remove()

    local hero = self.owner 
	
	hero:add('物爆几率',-self.physical_rate)
	hero:add('物爆伤害',-self.physical_damage)
	hero:add('会心几率',-self.heart_rate)
	hero:add('会心伤害',-self.heart_damage)
	hero:add('法爆几率',-self.magic_rate)
	hero:add('法爆伤害',-self.magic_damage)

end
