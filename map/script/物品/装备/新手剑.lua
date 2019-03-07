--物品名称
local mt = ac.skill['新手剑']
mt{

tip = [[
    闪烁,cd%cool%s.
]],

--技能图标
art = [[ReplaceableTextures\CommandButtons\BTNBlink.blp]],
cool = 10,

target_type = ac.skill.TARGET_TYPE_POINT,


--施法距离
range = 99999,
--移动距离
blink_range = 1000,
--新目标点
new_point =nil,


}


function mt:on_add()
    -- print('施法-添加技能',self.name)
    print('攻击：',self['攻击'])
    -- print(self.lni_tip)
    -- print(self.tip)
    
    -- print(self.cool)
    print('新手剑技能添加')

end
-- 物品只支持施法开始，额外支出施法出手
function mt:on_cast_start()
    local hero = self.owner
    local target = self.target
    print(hero,target)
    -- print(self.tip)
    
    print(self.cool)
    print('新手剑技能使用')
end

function mt:on_cast_shot()
    print('新手剑出手')

end    
function mt:on_remove()
    -- print('施法-删除技能',self.name)
end