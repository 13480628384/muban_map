local jass = require 'jass.common'
local mt = ac.book_skill['魔法书2']
mt{
	level = 1,
	instant = 1,
	force_cast = 1,
	never_reload = true,
	never_copy = true,
	art = [[ReplaceableTextures\CommandButtons\BTNSkillz.blp]],
	cool = 0,
	cost = 0,
	ability_id = 'AB32',
}

table.insert(mt.sub_skills, {
	art = [[sxzh1.blp]],
	title = '测试1',
	tip = '测试tip1',
})

table.insert(mt.sub_skills, {
	art = [[model\megumin\BTNMeguminR2.blp]],
	title = '和真的支援！生命吸收',
	tip = '每%explosion_cool%秒，你的下一个|cffff3333爆裂魔法|r不需要消耗魔力。',
	explosion_cool = function (self)
		return ('%.2f'):format(100 / self.owner:get_resource '魔力恢复')
	end,
})

table.insert(mt.sub_skills, {
	art = [[sxzh2.blp]],
	title = '测试2',
	tip = '测试tip2',
})

table.insert(mt.sub_skills, false)


for _, skill in ipairs(mt.sub_skills) do
	if skill then
		skill.simple_tip = true
		skill.max_level = 1
	end
end


function mt:on_cast_shot(skill)
	local hero = self.owner
	skill:set_art(skill:get_art(nil, true))
	skill:remove()
	-- table.insert(self.sub_skill.upgraded, skill)
	print(skill.title)
	-- self.sub_skill.upgraded[skill.title] = true
	-- self.sub_skill:fresh_tip()
	-- hero:get_owner():play_sound([[response\惠惠\skill\]] .. skill.sub_id .. '.mp3', '等待')
	-- self.upgraded = self.sub_skill.upgraded

	-- if skill.title == '超级！爆裂魔法' then
	-- 	self.sub_skill.explosion:explosion_update_data('range', nil, 1.5)
	-- 	self.sub_skill.explosion:explosion_update_data('area', nil, 1.5)
	-- 	self.sub_skill.explosion:explosion_update_data('cast_channel_time', nil, 1.5)
	-- elseif skill.title == '高速吟唱！爆裂魔法' then
	-- 	self.sub_skill.explosion:explosion_update_data('cast_channel_time', -1)
	-- 	self.sub_skill.explosion.explosion_fast_channel = true
	-- elseif skill.title == '维兹的爆裂魔法' then
	-- 	self.sub_skill.explosion.explosion_nohard = true
	-- 	hero:add_resource('魔力上限%', 20)
	-- elseif skill.title == '和真的支援！生命吸收' then
	-- 	hero:add_buff '爆裂魔法-生命吸收'
	-- 	{
	-- 		skill = self.sub_skill.explosion,
	-- 	}
	-- elseif skill.title == '爆裂魔法的虚实之道' then
	-- 	self.sub_skill.explosion.explosion_can_convert = true
	-- elseif skill.title == '超电磁炮！压缩爆裂魔法' then
	-- 	self.sub_skill.explosion:explosion_update_data('damage_rate', 0.3)
	-- 	self.sub_skill.explosion:explosion_update_data('damage_pene_rate', 30)
	-- elseif skill.title == '惠惠的爆裂之道' then
	-- 	self.sub_skill.explosion.explosion_training_building = true
	-- end
	-- self.sub_skill.explosion:explosion_update_data('damage_ratio', self.sub_skill:get_level() * 1)
	-- self.sub_skill.explosion:explosion_fresh()
end
