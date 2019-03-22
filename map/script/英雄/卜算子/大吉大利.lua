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
		以法器连接一名敌人，每0.5秒造成 攻击力*1+智力*3 的法术伤害 (%damage%) ；超过 %range% 距离断开
		被动：物品获取率+ %item_rate% %金钱获得+ %gold_rate% %
	]],
	
	--技能图标
	art = [[jineng\jineng010.blp]],

	--技能目标类型 单位目标
	target_type = ac.skill.TARGET_TYPE_UNIT,

	--增加主属性
	target_main_attr = 30,

	--减少主属性 
	source_main_attr = 30,

	--伤害
	damage = function(self,hero)
		return hero:get('攻击')*1 + hero:get('智力')*3
	end,

	--物品获取率
	item_rate = {10,20,30,40,50},
	--金币获取率
	gold_rate = {10,20,30,40,50},

	--每秒
	pulse = 0.5,

	--cd
	cool = 0,

	--耗蓝
	cost = 10,

	--施法距离
	range = 1200,

	--目标允许	
	target_data = '玩家单位 联盟  敌人',

	--强制施法
	-- range = 1200,
}

mt.item_rate_now = 0
mt.gold_rate_now = 0
function mt:on_add()
	local hero = self.owner 

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
	print('目标单位0',target_unit)
    local skill = self
	local hero = self.owner
	-- hero:add_effect('origin',self.effect)
	local target = self.target
	--如果已经有牵引着，先删旧的，再添加
	if self:get_stack() > 0 and hero:find_buff('大吉大利') then  
		hero:remove_buff('大吉大利')
	end	
	hero:add_buff '大吉大利' 
	{
		source_unit = hero,
		target_unit = target,
		skill = self,
		range = self.range,
		damage = self.damage,
		source_main_attr = self.source_main_attr,
		target_main_attr = self.target_main_attr,
		pulse = 0.5,
	}
end

function mt:on_remove()
    local hero = self.owner 
	hero:add('物品获取率',-self.item_rate)
	hero:add('金币加成',-self.gold_rate)
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end    

end


local mt = ac.buff['大吉大利']

mt.cover_type = 1
mt.cover_max = 1

function mt:on_add()
	local source_unit = self.source_unit
	local target_unit = self.target_unit
	print('目标单位1',target_unit)
	--标识 目标被牵引 
	self.target_unit.is_tacking = true

	self.skill:add_stack(1)
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
		print(self.target_unit,main_attr)

		local main_attr = self.source_unit.main_attribute..'%'
		self.source_unit:add(main_attr,-self.source_main_attr)
		print(self.source_unit,main_attr)
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
	self.skill:add_stack(-1)

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



