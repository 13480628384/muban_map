local mt = ac.skill['妙手空空']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能类型
	skill_type = "主动",
	--耗蓝
	cost = 25,
	--冷却时间
	cool = 15,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_UNIT,
	--施法距离
	range = 800,
	--介绍
	tip = [[盗取敌人身上物品，成功概率等于怪物的物品掉率，CD15S]],
	--技能图标
	art = [[jineng\jineng025.blp]],

	--几率
	-- chance = 100,
}
	
function mt:on_add()
	local hero = self.owner 

end	
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	local target = self.target
	ac.game:event_dispatch('物品-偷窃',target,hero) 

end

function mt:on_remove()
    local hero = self.owner 
    if self.trg then
        self.trg:remove()
        self.trg = nil
	end  
end
