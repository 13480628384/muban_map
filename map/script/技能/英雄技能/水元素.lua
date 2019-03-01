local mt = ac.skill['水元素']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = 60,
	--冷却时间
	cool = 40,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[召唤1只水元素帮助英雄作战（当前波属性的一半）；持续时间30S；CD40S]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNSummonWaterElemental.blp]],
	--特效
	effect = [[units\human\WaterElemental\WaterElemental.mdl]],
	--召唤物
	unit_name = "水元素",
	--召唤物属性倍数
	attr_mul = 0.5,
	--持续时间
	time = 30,
	--数量
	cnt = 1,
}
	
function mt:on_add()
	local hero = self.owner 

end	
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	
	local cnt = (self.cnt + hero:get('召唤物')) or 1
	--多个召唤物
	for i=1,cnt do 

		local point = hero:get_point()-{hero:get_facing(),100}--在英雄附近 100 到 400 码 随机点
		local unit = hero:get_owner():create_unit(self.unit_name,point)	

		local index = ac.creep['刷怪'].index
		-- print('技能使用时 当前波数',index)
		local data = ac.table.UnitData['进攻怪-'..index]

		self.buff = unit:add_buff '召唤物' {
			time = self.time,
			attribute = data.attribute,
			attr_mul = self.attr_mul - 1,
			skill = self,
			follow = true
		}
		
		unit:add('攻击距离',800)
	end	


end

function mt:on_remove()

    local hero = self.owner 
	--移除时将召唤物移除
    -- if self.buff then
    --     self.buff:remove()
    --     self.buff = nil
	-- end  
	
end