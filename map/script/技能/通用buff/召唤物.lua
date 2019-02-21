local mt = ac.buff['召唤物']

mt.cover_type = 1
mt.cover_max = 1

mt.mul = 1

mt.ref = 'origin'

function mt:on_add()
    local player = self.target:get_owner()
	--改变模型
	if self.model then
		japi.SetUnitModel(self.target.handle,self.model)
	end
	--设置模型大小
	if self.size then
		self.target:set_size(self.size)
    end
    
    --设置属性
	if self.attribute then
		for k, v in pairs(self.attribute) do
			self.target:set(k, v*self.mul)
		end
    end
    
	if self.follow == true then
		self.target:add_buff '召唤物跟随'
		{
			hero = player.hero,
			skill = self.skill,
		}
	end
    
end

function mt:on_remove()
    if self.effect then 
        self.effect:remove()
    end     
    -- 召唤物buff 移除时 ，移除召唤物 ， 不受单位死亡事件
    self.target:remove()
end

function mt:on_cover(new)
	if new.time > self:get_remaining() then
		self:set_remaining(new.time)
	end
	return false
end


local mt = ac.buff['召唤物跟随']
mt.pulse = 2

function mt:on_pulse()
	local target = self.target
	local hero = self.hero
	local point = hero:get_point() - {math.random(0,360),math.random(100,300)}
    target:issue_order('attack',point)
end