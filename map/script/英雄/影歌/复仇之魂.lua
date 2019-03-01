local mt = ac.skill['复仇之魂']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	--是否被动
	passive = true,
	
	tip = [[
		被动：攻击有 %chance% % 概率召唤 复仇之魂 (无敌,无碰撞体积，属性为当前波的怪物基础值的一半，拥有和英雄一样的经验、金币、物品获取率）
		|cff1FA5EE召唤物|r:
	]],
	
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNSpiritOfVengeance.blp]],

	--技能目标类型 无目标
	target_type = ac.skill.TARGET_TYPE_NONE,

	--几率
	chance = 5,

	--持续时间
	time = 30,


	--特效模型
	effect = [[units\nightelf\Vengeance\Vengeance.mdl]],
	weapon_model = [[Abilities\Weapons\VengeanceMissile\VengeanceMissile.mdl]]
	
}
function mt:on_add()
    local skill = self
	local hero = self.owner
	
	self.trg = hero:event '单位-发动攻击'  (function(trg, damage)

		local rand = math.random(1,100)

		if rand <= self.chance then 

			local point = hero:get_point()-{hero:get_facing(),100}
			local unit = hero:get_owner():create_unit('幻象马甲-蝗虫',point)	
			local index = ac.creep['刷怪'].index
			local unit_data = ac.table.UnitData['进攻怪-'..index]

			local data ={}
			data.attribute = {}
			for k, v in pairs(unit_data.attribute) do
				data.attribute[k] = v 
			end
			data.attribute['攻击'] = data.attribute['攻击'] * 0.5
			
			self.buff = unit:add_buff '召唤物' {
				skill = self,
				time = self.time,
				attribute = data.attribute,
				model = self.effect,
			}
			unit:add_restriction '无敌'
			
			unit:add('攻击距离', 800)
			if not unit.weapon then 
				unit.weapon = {}
			end    
			unit.weapon['弹道模型'] = self.weapon_model
			unit.weapon['弹道速度'] = 1000

		end	

	end)	

end	

function mt:on_remove()

    local hero = self.owner 
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end  
    -- if self.buff then
    --     self.buff:remove()
    --     self.buff = nil
    -- end     

end
