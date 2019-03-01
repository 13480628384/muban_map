local mt = ac.buff['时停']

mt.cover_type = 1
mt.cover_max = 1

mt.control = 10
mt.debuff = true
mt.model = [[]]

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

   
end
