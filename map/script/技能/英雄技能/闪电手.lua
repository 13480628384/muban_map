local mt = ac.skill['闪电手']

mt{
	--必填
	is_skill = true,

	--是否被动
	passive = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		|cff00ccff被动|r:
		攻速+%attack_speed% % 
	]],
	
	--技能图标
	art = [[jineng\jineng013.blp]],

	--攻速
	attack_speed = 20,

}


function mt:on_add()
	local skill = self
	local hero = self.owner 

	hero:add('攻击速度',self.attack_speed)

end	

function mt:on_remove()

    local hero = self.owner 
	hero:add('攻击速度',-self.attack_speed)

	

end
