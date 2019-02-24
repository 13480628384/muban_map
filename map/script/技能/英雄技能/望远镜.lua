local mt = ac.skill['望远镜']

mt{
	--必填
	is_skill = true,

	--是否被动
	passive = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		|cff00ccff被动|r:
		攻击距离加 %attack_range% %

	]],
	attack_range = 20,
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNEvasion.blp]],

	--闪避
	dodge = 20,

}


function mt:on_add()
	local skill = self
	local hero = self.owner 

	hero:add('攻击距离%',self.attack_range)

end	

function mt:on_remove()

    local hero = self.owner 
	hero:add('攻击距离%',-self.attack_range)

	

end
