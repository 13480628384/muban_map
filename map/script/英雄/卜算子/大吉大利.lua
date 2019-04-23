local mt = ac.skill['大吉大利']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	max_level = 5,
	
	tip = [[
		主动：同时只能连接一个目标；
		以法器连接一名队友，减少自己主属性 %source_main_attr% %，增加队友主属性 %target_main_attr% %
		以法器连接一名敌人，每0.5秒造成 攻击力*2+智力*5 的法术伤害 (%damage%) ；超过 %target_range% 距离断开
		被动：物品获取率+ %item_rate% %金钱获得+ %gold_rate% %
		
		进阶后的技能效果： (%upgrade_tip%)
		法器可同时链接 多个队友或敌人 ，不减少自己的主属性。
	]],
	
	--技能图标
	art = [[jineng\jineng010.blp]],
	upgrade_tip = '未进阶',

	--技能目标类型 单位目标
	target_type = ac.skill.TARGET_TYPE_UNIT,

	--增加主属性
	target_main_attr = {35,40,45,50,55},

	--减少主属性 
	source_main_attr = {35,25,15,5,0},

	--伤害
	damage = function(self,hero)
		return hero:get('攻击')*2 + hero:get('智力')*5
	end,

	--物品获取率
	item_rate = {50,75,100,125,150},
	--金币获取率
	gold_rate = {50,75,100,125,150},

	--每秒
	pulse = 0.5,

	--cd
	cool = 0,

	--耗蓝
	cost = {25,130,235,340,450},

	--施法距离
	range = 1200,
	--目标允许	
	target_data = '玩家单位 联盟  敌人',

	--牵引保持距离
	target_range = 1200,
	--强制施法
	-- range = 1200,
}

mt.item_rate_now = 0
mt.gold_rate_now = 0
function mt:on_add()
	local hero = self.owner 
	local player = hero:get_owner()
	-- 增强 卜算子 技能 1个变为多个
	if player.mall and player.mall['黑魔导'] then 
		self:set('target_type',ac.skill.TARGET_TYPE_POINT)
		self:set('area',500)
		self:set('target_range',1500)
		self:set('upgrade_tip','已进阶')
		local source_main_attr = {0,0,0,0,0}
		self:set('source_main_attr',source_main_attr)
		-- print(2222222222222222222)
	end	

	--判断是否买了商城道具
	-- local player = 


end	
function mt:on_upgrade()
	local hero = self.owner
	-- print(self.life_rate_now)

	hero:add('物品获取率', -self.item_rate_now)
	self.item_rate_now = self.item_rate
	hero:add('物品获取率', self.item_rate)
	
	hero:add('金币加成', -self.gold_rate_now)
	self.gold_rate_now = self.gold_rate
	hero:add('金币加成', self.gold_rate)

end


function mt:on_cast_shot()
	-- print('目标单位0',target_unit)
    local skill = self
	local hero = self.owner
	-- hero:add_effect('origin',self.effect)
	local target = self.target
	-- print(target.type)
	--如果已经有牵引着，先删旧的，再添加 self:get_stack() > 0

	if not self.target_mark then 
		self.target_mark ={}
	end	
	if next(self.target_mark) ~= nil then
		for i=1,#self.target_mark do
			local target = self.target_mark[i]
			target:remove()
			self.target_mark[i] = nil
		end	
	end	

	if target.type == 'point' then 
		for i,u in ac.selector()
			: in_range(target:get_point(),self.area)
			: of_not_building()
			: ipairs()
		do
			if  u:find_buff('大吉大利') then  
				u:remove_buff('大吉大利')
			end	
			local buff =u:add_buff '大吉大利' 
			{
				source_unit = hero,
				target_unit = u,
				skill = self,
				range = self.target_range,
				damage = self.damage,
				source_main_attr = self.source_main_attr,
				target_main_attr = self.target_main_attr,
				pulse = 0.5,
			}
			table.insert(self.target_mark,buff)
		end	
	else
		if target:find_buff('大吉大利') then  
			target:remove_buff('大吉大利')
		end	
		local buff = target:add_buff '大吉大利' 
		{
			source_unit = hero,
			target_unit = target,
			skill = self,
			range = self.target_range,
			damage = self.damage,
			source_main_attr = self.source_main_attr,
			target_main_attr = self.target_main_attr,
			pulse = 0.5,
		}
		table.insert(self.target_mark,buff)
	end	
	self:set('target_mark',self.target_mark)
end

function mt:on_remove()
    local hero = self.owner 
	hero:add('物品获取率',-self.item_rate)
	hero:add('金币加成',-self.gold_rate)
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end   
	if  self.target_mark then 
		if next(self.target_mark) ~= nil then
			for i=1,#self.target_mark do
				local target = self.target_mark[i]
				target:remove()
				self.target_mark[i] = nil
			end	
		end	 
	end	

end


local mt = ac.buff['大吉大利']

mt.cover_type = 1
mt.cover_max = 1

function mt:on_add()
	local source_unit = self.source_unit
	local target_unit = self.target_unit
	-- print('目标单位1',target_unit)
	--标识 目标被牵引 
	self.target_unit.is_tacking = true

	-- self.skill:add_stack(1)
    --计算高度
    local function get_hith(u)
        local weapon_launch = u.weapon and u.weapon['弹道出手']
        local launch_z = weapon_launch and weapon_launch[3] or u:get_slk('launchZ', 0)
        launch_z = u:get_high() + launch_z
        return launch_z
	end
	
    self.ln = ac.lightning('LN07', source_unit, target_unit,get_hith(source_unit),get_hith(target_unit))
	self.ln.keep_visible = true
	
	-- print('目标单位22222',self.target_unit:is_hero(),self.target_unit:is_ally(self.source_unit),self.source_unit.unit_type )
	--目标单位是英雄且是友军 增加目标属性，减少自身属性
	if self.target_unit:is_hero() and self.target_unit:is_ally(self.source_unit)  then 

		local main_attr = self.target_unit.main_attribute..'%'
		self.target_unit:add(main_attr,self.target_main_attr)
		-- print(self.target_unit,main_attr)

		local main_attr = self.source_unit.main_attribute..'%'
		self.source_unit:add(main_attr,-self.source_main_attr)
		-- print(self.source_unit,main_attr)
	end	

	self.target_unit:event '单位-死亡'(function(trg,unit,killer)
		if self.target_unit.is_tacking then 
			self:remove()
		end	
	end)


	-- self:on_pulse()
end
function mt:on_pulse()
	-- print(self.target_unit)
	local distance = self.source_unit:get_point() * self.target_unit:get_point()
	--超出距离，移除buff
	if distance > self.range then 
		self:remove()
		return
	end	
	--进行伤害
	if self.target_unit:is_enemy(self.source_unit) then 
		self.target_unit:damage
		{
			source = self.source_unit,
			skill = self.skill,
			damage = self.damage,
			damage_type = '法术'
		}
	end	

end	
function mt:on_remove()
	self.target_unit.is_tacking = false
	-- self.skill:add_stack(-1)

	--目标单位是英雄且是友军 
	if self.target_unit:is_hero() and self.target_unit:is_ally(self.source_unit)  then 

		local main_attr = self.target_unit.main_attribute..'%'
		self.target_unit:add(main_attr,-self.target_main_attr)

		local main_attr = self.source_unit.main_attribute..'%'
		self.source_unit:add(main_attr,self.source_main_attr)
	end	

	if self.ln then
		self.ln:remove()
	end
end



