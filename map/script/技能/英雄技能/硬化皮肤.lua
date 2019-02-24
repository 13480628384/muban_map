local mt = ac.skill['硬化皮肤']

mt{
	--必填
	is_skill = true,

	--是否被动
	passive = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		|cff00ccff被动|r:
		护甲加 %defence% %

	]],
	
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNResistantSkin.blp]],

	--护甲
	defence = 20,

}


function mt:on_add()
	local skill = self
	local hero = self.owner 

	hero:add('护甲%',self.defence)

end	

function mt:on_remove()

    local hero = self.owner 
	hero:add('护甲%',-self.defence)

	

end
