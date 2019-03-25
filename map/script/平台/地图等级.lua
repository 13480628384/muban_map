local japi = require("jass.japi")
local mt = ac.skill['地图等级']
mt{
    --必填
    is_skill = true,
    --是否被动
    passive = true,
    --初始等级
    level = 1,
	--介绍
    tip = [[
金币加成 %map_level% %
经验加成 %map_level% %
物品获取率 %map_level% %
    ]],
    map_level = function(self,hero)
		if self and self.owner and self.owner:get_owner() then 
			return self.owner:get_owner():Map_GetMapLevel() or 0
		end	
    end,    
	--技能图标
	art = [[icon\jineng040.blp]],
	--特效
	effect = [[]],
	--获得积分双倍
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    local p = hero:get_owner()
    --加成到英雄身上
    hero = p.hero
    hero:add('金币加成',self.map_level)
    hero:add('经验加成',self.map_level)
    hero:add('物品获取率',self.map_level)
    --添加称号
    -- self.trg = hero:add_effect('chest',self.effect)
end
function mt:on_remove()
    local hero = self.owner
    local p = hero:get_owner()
    hero = p.hero
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    hero:add('金币加成',-self.map_level)
    hero:add('经验加成',-self.map_level)
    hero:add('物品获取率',-self.map_level)
    
end
