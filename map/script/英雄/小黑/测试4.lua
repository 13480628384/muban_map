local mt = ac.skill['测试4']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNScatterRockets.blp]],

	target_type = ac.skill.TARGET_TYPE_POINT,

	--技能说明
	title = '测试2',

	tip = [[测试2
	第二行
	]],
	--施法距离
	range = 99999,
}

function mt:on_cast_channel()
	local hero = self.owner
	print('施放 测试4技能, 技能id :',self.ability_id)
end
