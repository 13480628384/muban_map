local mt = ac.skill['死吻']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		主动：双手沾满鲜血，攻击力提升 %attack_mul% 倍，持续 %time% 秒,cd %cool% 秒
		被动1：周围 %area% 码有敌人死亡，刷新所有技能的冷却时间
		被动2：攻击对敌人造成护甲 -%reduce_defence% % ,持续 %reduce_defence_time% 秒
	]],
	
	--技能图标
	art = [[jineng\jineng005.blp]],

	--技能目标类型 无目标
	target_type = ac.skill.TARGET_TYPE_NONE,

	--攻击
	attack_mul = 1,

	--持续时间
	time = 3,

	--cd 25
	cool = 10,

	--耗蓝
	cost = 10,

	--护甲持续时间
	reduce_defence_time = 5,

	--特效模型
	effect = [[Abilities\Spells\Orc\Bloodlust\BloodlustTarget.mdl]],

	-- 周围范围
	area = 600,
	-- 攻击减护甲
	reduce_defence = 20,
	--施法距离
	-- range = 99999,
}


function mt:on_add()
    local skill = self
	local hero = self.owner 
	
	self.trg1 = hero:add_buff '死吻-被动1' 
	{
		source = hero,
		skill = self,
		area = self.area,
		pulse = 0.02, --立即生效
		real_pulse = 0.1  --实际每几秒检测一次
	}

	self.trg2 = hero:event '造成伤害效果' (function(trg, damage)
		local target = damage.target
		target:add_buff '死吻-被动2' 
		{
			source = hero,
			skill = self,
			reduce_defence = self.reduce_defence,
			time = self.reduce_defence_time,
		}
	end)

end	
function mt:on_cast_shot()
	local hero = self.owner
	-- hero:add_effect('origin',self.effect)
	self.trg = hero:add_buff '死吻' 
	{
		source = hero,
		skill = self,
		attack_mul = self.attack_mul,
		time = self.time
	}

	
end

function mt:on_remove()

    local hero = self.owner 
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end   
    if self.trg1 then
        self.trg1:remove()
        self.trg1 = nil
    end    
    if self.trg2 then
        self.trg2:remove()
        self.trg2 = nil
    end     

end

local mt = ac.buff['死吻']
mt.cover_type = 1
mt.cover_max = 1

function mt:on_add()
    self.eff = self.target:add_effect('chest',self.effect)
	self.target:add('攻击%', self.attack_mul*100)
end

function mt:on_remove()
    if self.eff then 
        self.eff:remove()
        self.eff = nil
    end    
	self.target:add('攻击%', - self.attack_mul*100)
    
end

function mt:on_cover(new)
	if new.time > self:get_remaining() then
		self:set_remaining(new.time)
	end
	return false
end




local mt = ac.buff['死吻-被动1']

mt.cover_type = 1

function mt:on_add()
	local hero = self.target
	self.unit_mark = {}
end

function mt:on_pulse()
	-- print('腐烂每秒伤害：',damage*self.pulse)
	local hero = self.target
	self.pulse = self.real_pulse
	self.cnt = 0

	for i, u in ac.selector()
		: in_range(hero,self.area)
		: of_not_building()
		: is_enemy(hero)
		: allow_dead()
		: ipairs()
	do
		if not u:is_alive() and not self.unit_mark[u] then 
			self.unit_mark[u] = true
			self.cnt = self.cnt + 1
		end
	end	
	if self.cnt > 0  then 
		--刷新技能
		for skl in hero:each_skill() do
			if skl:get_type() == '英雄' then
				-- print('即将刷新技能',skl:get_name())
				skl:set_cd(0)
				skl:fresh()
			end	
		end	

	end
	-- print('周围单位个数：'..self.skill.cnt,hero:get('攻击%'))
end

function mt:on_remove()
    
end


local mt = ac.buff['死吻-被动2']
mt.cover_type = 1
mt.cover_max = 1

function mt:on_add()
	-- self.eff = self.target:add_effect('origin',self.effect)
	-- print('减护甲',self.target)
	self.target:add('护甲%', - self.reduce_defence)
end

function mt:on_remove()
    -- if self.eff then 
    --     self.eff:remove()
    --     self.eff = nil
    -- end    
	self.target:add('护甲%',  self.reduce_defence)
    
end

function mt:on_cover(new)
	if new.time > self:get_remaining() then
		self:set_remaining(new.time)
	end
	return false
end
