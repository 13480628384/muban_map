local mt = ac.skill['复仇天神']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		主动：创造一个强大的复仇天神（远程攻击，属性和当前波的怪物基础值一致，拥有和英雄一样的经验、金币、物品获取率），
			 这个天神攻击有 %fuchou_chance% % 概率 召唤无敌的复仇之魂（无碰撞体积，攻击为当前波的怪物基础值的一半，拥有和英雄一样的经验、金币、物品获取率），
			 持续 %time% 秒；
		被动：攻击有 %chance% % 概率召唤 复仇之魂

		|cff1FA5EE召唤物|r:

	]],
	
	--技能图标 3（60°扇形分三条，角度30%）+3+3+1+1，一共5波，
	art = [[ReplaceableTextures\CommandButtons\BTNSpiritOfVengeance.blp]],

	--技能目标类型 无目标
	target_type = ac.skill.TARGET_TYPE_NONE,

	--几率
	chance = 5,

	--复仇天神几率
	fuchou_chance = 10,

	--cd 45
	cool = 1,

	--耗蓝
	cost = 60,

	--持续时间
	time = 30,


	--特效模型
	effect = [[]],
	
	
}
function mt:on_add()
	local hero = self.owner 
	local skill = hero:add_skill('复仇之魂','隐藏')
	skill.chance = self.chance

end	
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	local point = hero:get_point()-{hero:get_facing(),100}--在英雄附近 100 到 400 码 随机点
	local unit = hero:get_owner():create_unit('复仇天神',point)	

	local index = ac.creep['刷怪'].index
	if not index or index == 0 then 
		index = 1
	end	
	-- print('技能使用时 当前波数',index)
	local data = ac.table.UnitData['进攻怪-'..index]

	self.buff = unit:add_buff '召唤物' {
		time = 30,
		attribute = data.attribute,
		skill = self,
	}

	local skl = unit:add_skill('复仇之魂','英雄')
	skl.chance = self.fuchou_chance
	-- print(unit:get('移动速度'))
	

end

function mt:on_remove()

    local hero = self.owner 
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
	end  
	if hero:find_skill('复仇之魂') then 
		hero:remove_skill('复仇之魂')
	end	
	
    -- if self.buff then
    --     self.buff:remove()
    --     self.buff = nil
    -- end     

end
