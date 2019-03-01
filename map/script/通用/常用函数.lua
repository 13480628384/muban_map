--获取区域内随机单位
ac.get_random_unit = function(loc,unit,range)
	local target
	local group = {}
	for _,u in ac.selector()
		: in_range(loc,range)
		: is_enemy(unit)
		: ipairs()
	do
		table.insert(group,u)
	end
	if #group > 0 then
		target = group[math.random(1,#group)]
	end

	return target
end