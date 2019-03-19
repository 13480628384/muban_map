local mt = ac.skill['闪避']

mt{
	--必填
	is_skill = true,

	--是否被动
	passive = true,
	--技能类型
	skill_type = "被动",
	
	--初始等级
	level = 1,
	
	tip = [[
		|cff00ccff被动|r:
		闪避加 %dodge% %

	]],
	
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNEvasion.blp]],

	--闪避
	dodge = 20,

}


function mt:on_add()
	local skill = self
	local hero = self.owner 

	hero:add('闪避',self.dodge)

end	

function mt:on_remove()

    local hero = self.owner 
	hero:add('闪避',-self.dodge)

end
