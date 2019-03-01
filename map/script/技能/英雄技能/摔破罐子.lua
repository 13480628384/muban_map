local mt = ac.skill['摔破罐子']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = 1,
	--冷却时间90
	cool = 1,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_UNIT,
	--施法距离
	range = 500,
	--介绍
	tip = [[直接杀死一名敌人（BOSS不行），永久降低自身15%的智力，但50%获得一个物品掉落]],
	--技能图标
	art = [[jineng\jineng027.blp]],
	--扣智力
	addint = 15,
	--几率
	rate = 100,
}
function mt:on_add()
    local skill = self
    local hero = self.owner
end
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	local target = self.target
	-- print(target,target.data.type)

	local ln = ac.lightning('LN00',hero,target,50,50)
	ln:fade(-5)
	if target.data.type =='boss' then
		hero:add('魔法',self.cost)
		self:set_cd(0)
		self:fresh()
	else
		target:kill()
		hero:add('智力',- math.ceil(hero:get('智力')*self.addint/100))
		local rand = math.random(1,100)
		if rand <= self.rate then 
			--@目标单位
			--@源单位,继承英雄获得物品获取率
			ac.game:event_dispatch('物品-随机装备',target,hero) 
		end	
	end	
	
end	
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
end