local mt = ac.skill['舍生取义']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		主动：每秒恢复 %life_rate% %的血量，持续时间 %time% 秒, 冷却 %cool%秒
		被动：每损失1点的最大生命值， 额外获得 %attack% 点的攻击力提升
	]],
	
	--技能图标
	art = [[jineng\jineng001.blp]],

	--技能目标类型 无目标
	target_type = ac.skill.TARGET_TYPE_NONE,

	--施法范围
	area = 500,

	--持续时间
	time = 10,

	--每几秒
	pulse = 0.2,

	--生命上限
	life_rate = 6,

	--攻击提升
	attack = 1,
	--cd
	cool = 20,

	--耗蓝
	cost = 35,

	--特效模型
	effect = [[Hero_Juggernaut_N4S_F_Source.mdx]],
	--施法距离
	-- range = 99999,
}


function mt:on_add()
    local skill = self
	local hero = self.owner 

	self.trg = hero:add_buff '舍生取义-被动' 
	{
		source = hero,
		skill = self,
		attack = self.attack,
		pulse = 0.02, --立即生效
		real_pulse = 0.1  --实际每几秒检测一次
	}

end	
function mt:on_cast_shot()
	local hero = self.owner
	-- hero:add_effect('origin',self.effect)
	self.trg = hero:add_buff '舍生取义' 
	{
		source = hero,
		skill = self,
		life_rate = self.life_rate,
		time = self.time,
		pulse = 0.02, --立即生效
		real_pulse = 1  --实际每几秒检测一次
	}
end

function mt:on_remove()

	
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end    

end


local mt = ac.buff['舍生取义']

function mt:on_add()
	local hero = self.target
	--特效

end

function mt:on_pulse()
	local hero = self.target
	self.pulse = self.real_pulse
	hero:heal 
	{
		source = hero,
		skill = self.skill,
		size = 10,
		-- string = '治疗',
		heal = hero:get('生命上限')*self.life_rate/100 ,
	}

end	
function mt:on_remove()
    
end

local mt = ac.buff['舍生取义-被动']

mt.cover_type = 1

function mt:on_add()
	local hero = self.target
	--特效

end

function mt:on_pulse()
	local hero = self.target
	self.pulse = self.real_pulse
	--每 0.2 秒检测周围单位一次，先移除上次增加的攻击，再重新计算添加。
	if self.skill.cnt then 
		hero:add('攻击',-self.skill.cnt*self.attack)
	end	

	self.skill.cnt = hero:get('生命上限') - hero:get('生命')
	
	hero:add('攻击',self.skill.cnt*self.attack)
	-- print('周围单位个数：'..self.skill.cnt,hero:get('攻击%'))
end

function mt:on_remove()
    
end