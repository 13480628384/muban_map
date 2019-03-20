--物品名称
local mt = ac.skill['新手礼包']
mt{
--等久
level = 1,

--图标
art = [[xin101.blp]],

--说明
tip = [[    
1000元
随机技能书*1
生命药水*10
新人寻宝石
]],

--物品类型
item_type = '消耗品',

--目标类型
target_type = ac.skill.TARGET_TYPE_NONE,

--冷却
cool = 1,

--购买价格
gold = 0,

}


function mt:on_cast_start()
    local hero = self.owner
    local target = self.target
    local items = self
    
    -- 宠物可以帮忙吃
    hero = hero:get_owner().hero
    -- items._count = items._count - 1
    
    --添加给英雄
    hero:addGold(1000)
    hero:add_item('随机技能书',true)
    hero:add_item('生命药水',true)
    hero:add_item('新人寻宝石',true)


end