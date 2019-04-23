local mt = ac.skill['硬币机器']
mt{
    --必填
    is_skill = true,
    --初始等级
	level = 1,
	max_level = 5,
	--技能类型
	skill_type = "召唤 智力",
	--耗蓝
	cost = {70,200,350,500,750},
	--冷却时间
	cool = 25,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[|cff11ccff%skill_type%:|r 召唤1只硬币机器助战
	
	|cff00bdec召唤物属性：和智力相关|r 

	|cff00bdec召唤物技能：硬化皮肤、攻击时有概率获得额外金币|r
	]],
	--技能图标
	art = [[ReplaceableTextures\CommandButtons\BTNChestOfGold.blp]],
	--特效
	effect = [[units\human\WarWagon\WarWagon.mdl]],
	--召唤物
	unit_name = "硬币机器",
	--召唤物属性倍数
	attr_mul = 1,
	--持续时间
	time = {15,20,25,30,35},
	--数量
	cnt = 1,

	--几率
	chance = 15,
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
		if not index or index == 0 then 
			index = 1
		end	
		index = index + ac.creep['刷怪-无尽'].index 

		local life_mul, defence_mul, attack_mul = ac.get_summon_mul(index)
		local data = {}
		data.attribute={
			['生命上限'] = hero:get('智力') * life_mul,
			['护甲'] = hero:get('智力') * defence_mul,
			['攻击'] = hero:get('智力') * attack_mul,
			['魔法上限'] = 60,
			['移动速度'] = 325,
			['攻击间隔'] = 1.2,
			['生命恢复'] = 1.2,
			['魔法恢复'] = 0.6,
			['攻击距离'] = 100,
		}
		-- data.gold * data.food 
		self.buff = unit:add_buff '召唤物' {
			time = self.time,
			attribute = data.attribute,
			attr_mul = self.attr_mul - 1,
			skill = self,
			follow = true
		}
		--加钱
		unit:event '造成伤害效果' (function(trg,damage)
			
			if not damage:is_common_attack()  then 
				return 
			end 
			local gold = damage.target.gold
			-- print(damage.target,gold)
			local rand = math.random(1,100)
			if rand <= self.chance then 
				unit:addGold(gold)
			end
		end)
		unit:add_skill('硬化皮肤','隐藏')
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