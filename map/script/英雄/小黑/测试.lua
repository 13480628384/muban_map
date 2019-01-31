local mt = ac.skill['测试']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNScatterRockets.blp]],

	--技能说明
	title = '测试',

	tip = [[这只是一个测试技能
	第二行
	]],
}

function mt:on_cast_channel()
	local hero = self.owner
end
