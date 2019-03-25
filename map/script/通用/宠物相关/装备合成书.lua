--物品名称
local mt = ac.skill['装备合成书']
mt{
    --物品技能
    is_skill = true,
    art = [[other\hecheng.blp]],
    tip = [[
|cff00ffff三个同品质装备 + 装备合成书 合成 更高品质|r

默认概率33.3% ，1个材料相同可提升 33.3% 概率，3个材料都相同合成概率 100%
    ]],
}


function mt:on_add()
    
end

function mt:on_cast_shot()
    local hero = self.owner
    hero:add_item('装备合成书')
end    
--实际是丢掉
function mt:on_remove()
end