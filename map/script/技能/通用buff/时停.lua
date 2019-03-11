local mt = ac.buff['时停']

mt.cover_type = 1
mt.cover_max = 1

mt.control = 10
mt.debuff = true
mt.model = [[]]

local function on_texttag(time,hero)
	local target = hero
	local x, y = target:get_point():get()
	local z = target:get_point():getZ()
	local tag = ac.texttag
	{
		string = tostring(time),
		size = 10,
		position = ac.point(x , y, z + 100),
		speed = 250,
		angle = 90,
		red = 238,
		green = 31,
		blue = 39,
		crit_size = 0,
		life = 1,
		fade = 0.5,
		time = ac.clock(),
	}
	
	if tag then 
		local i = 0
		ac.timer(10, 25, function()
			i = i + 1
			if i < 10 then
				tag.crit_size = tag.crit_size + 1

			else if i < 20 then
					tag.crit_size = tag.crit_size	
				else 
					tag.crit_size = tag.crit_size - 1
				end
			end	
			tag:setText(nil, tag.size + tag.crit_size)
		end)
	end	
end

function mt:on_add()
	if not self.eff and self.model then
		self.eff = self.target:add_effect('overhead', self.model)
	end
	self.target:add_restriction '时停'
	self.target:cast_stop()
	--移除特效
	ac.wait(self.time * 1000,function()
		if self.eff then
			self.eff:remove()
			self.eff = nil
		end
		self.target:remove_restriction '时停'
	end)
	-- 是否文字显示计时
	if self.show then
		local time = self.time 
		on_texttag(self.time,self.target)
		local timer = ac.timer(1*1000, math.ceil(self.time),function()
			time = time - 1
			on_texttag(time,self.target)
		end);
	end	
	-- function timer:on_timeout()
	-- 	self.target:remove_restriction '时停'
	-- end
   
end
