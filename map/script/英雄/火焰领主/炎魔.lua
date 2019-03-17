local mt = ac.skill['炎魔']

mt{
	--必填
	is_skill = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		主动：召唤一个炎魔(与当前波怪物的基础属性一样)，它会在杀死敌人的时候吸取其精华，并分裂为两个（状态和母体一致），持续 %time% 秒；
		被动： 本体 和 召唤物攻击，都附加 智力*1的法术攻击的伤害 （%%）
	]],
	
	--技能图标 
	art = [[ReplaceableTextures\CommandButtons\BTNLavaSpawn.blp]],

	--技能目标类型 无目标
	target_type = ac.skill.TARGET_TYPE_NONE,

	--伤害
	damage = function(self,hero)
		return hero:get('智力')*1
	end	,

	--cd 45
	cool = 45,

	--耗蓝
	cost = 60,

	--持续时间
	time = 25,


	--特效模型
	effect = [[Units\Creeps\LavaSpawn\LavaSpawn.mdl]],
	
	
}
function mt:on_add()
	local hero = self.owner 
	local skill = self
	self.trg = hero:event '造成伤害效果' (function(trg, damage)
		if not damage:is_common_attack() then 
			return
		end	
		local target = damage.target
		ac.wait(0.3*1000,function()
			target:damage
			{
				source = hero,
				damage = skill.damage,
				skill = skill,
				damage_type = '法术'
			}
		end)
	end)

end	
local function create_summon_unit(skill,where)
	local hero = skill.owner
	local point = where
	local unit = hero:get_owner():create_unit('炎魔',point)	

	local index = ac.creep['刷怪'].index
	if not index or index == 0 then 
		index = 1
	end	
	-- print('技能使用时 当前波数',index)
	local data = ac.table.UnitData['进攻怪-'..index]
	unit:add_buff '召唤物' {
		time = skill.time,
		attribute = data.attribute,
		skill = skill,
	}

	unit:event '单位-杀死单位' (function(trg, killer, target)
		local where = target:get_point() - { math.random(1,360) ,100 }
		create_summon_unit(skill,where)
	end)

	unit:event '造成伤害效果' (function(trg, damage)
		if not damage:is_common_attack() then 
			return
		end	
		local target = damage.target
		ac.wait(0.3*1000,function()
			target:damage
			{
				source = unit,
				damage = skill.damage,
				skill = skill,
				damage_type = '法术'
			}
		end)
	end)

	return unit
end	
function mt:on_cast_shot()
    local skill = self
	local hero = self.owner
	local where = hero:get_point() - { hero:get_facing(),100 }
	create_summon_unit(skill,where)
	
end

function mt:on_remove()

    local hero = self.owner 
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
	end   

end
