local mt = ac.skill['致命一击']

mt{
	--必填
	is_skill = true,

	--是否被动
	passive = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		|cff00ccff被动|r:
		攻击时有 %physical_rate% % 几率 造成物理暴击
	]],
	
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNCriticalStrike.blp]],

	--物爆
	physical_rate = 10,
	physical_damage = 50,


}


function mt:on_add()
	local skill = self
	local hero = self.owner 

	hero:add('物爆几率',self.physical_rate)

end	

function mt:on_remove()

    local hero = self.owner 
	
	hero:add('物爆几率',-self.physical_rate)

end
