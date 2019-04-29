
local rect = require 'types.rect'

--物品名称
local mt = ac.skill['进入小黑屋']
mt{
--等久
level = 1,

--图标
art = [[tanke.blp]],

--说明
tip = [[进入小黑屋|r]],

--物品类型
item_type = '神符',

--目标类型
target_type = ac.skill.TARGET_TYPE_NONE,

--冷却
cool = 0,

content_tip = '',
--物品技能
is_skill = true,
--增加值
value = 0.02

}

function mt:on_cast_start()
    local hero = self.owner
    local p = hero:get_owner()
    local rect = ac.rect.j_rect('lgfsg'..p.id)
    -- print(rect)
    hero:blink(rect,true,false,true)
end
