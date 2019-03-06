local mt = ac.skill['X射线']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		主动：在英雄朝向每 %pulse_time% 秒，发射一波X射线，每条造成攻击力*0.5+智力*1.5的法术伤害 (%damage%) ；
		被动：睿智，智力 + %int% %
	]],
	
	--技能图标 3（40°扇形分三条，角度20%）+3+3+1+1，一共5波，
	art = [[jineng\jineng032.blp]],

	--技能目标类型 无目标
	target_type = ac.skill.TARGET_TYPE_NONE,

	--持续时间
	pulse_time = 0.4,

	--角度
	angle = 20,

	--每次最大数量
	count = 3,

	--伤害
	damage = function(self,hero)
		return hero:get('攻击')*0.5 + hero:get('智力')*1.5
	end,	

	--cd 30
	cool = 1,

	--耗蓝
	cost = 35,

	--被动加的智力
	int = 20,

	--特效模型
	-- effect = [[Effect_coarse slash Blue.mdx]],
	effect = [[gx.mdx]],
	
	--X射线距离
	distance = 1600,
	--X射线速度
	speed = 1600,
	--碰撞范围
	hit_area = 100,
	-- effect = [[Hero_Juggernaut_N4S_F_Source.mdx]],
	
}
--X射线
--角度
local function damage_shot(skill,angle)
	local skill = skill
	local hero = skill.owner
	-- print('射线距离',skill.distance,skill.speed,angle)
	--X射线
	local mvr = ac.mover.line
	{
		source = hero,
		distance = skill.distance,
		speed = skill.speed,
		skill = skill,
		angle = angle,
		high = 110,
		model = skill.effect, 
		hit_area = skill.hit_area,
		hit_type = ac.mover.HIT_TYPE_ENEMY,
		size = 1
	}
	if not mvr then 
		return
	end
	function mvr:on_hit(dest)
		dest:damage
		{
			source = skill.owner,
			damage = skill.damage,
			skill = skill,
			missile = skill.mover,
			damage_type = '法术'
		}
	end	
end
function mt:on_add()
	local hero = self.owner 
	hero:add('智力%',self.int)

end	
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	-- hero:add_effect('origin',self.effect)
	-- local target = self.target
	-- local point = target:get_point()
	-- print(point)
	--在目标区域创建特效
	self.trg = hero:timer(self.pulse_time * 1000,5,function(t)
		local angle = hero:get_facing()
		if t.cnt <=2 then 
			--然后发射3枚射线
			for i = 1,skill.count do
				--计算角度
				local angle = angle + (skill.count / 2 - skill.count - 0.5 + i) * skill.angle
				damage_shot(skill,angle)
			end	
		else
			damage_shot(skill,angle)
		end	
	end)
	

end

function mt:on_remove()

    local hero = self.owner 
	hero:add('智力%',-self.int)
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end    

end
