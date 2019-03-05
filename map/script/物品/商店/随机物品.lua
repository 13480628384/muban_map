--物品名称
local mt = ac.skill['随机物品']
mt{
--等久
level = 1,

--图标
art = [[other\suiji101.blp]],

--说明
tip = [[
随机物品
]],

--物品类型
item_type = '神符',

--目标类型
target_type = ac.skill.TARGET_TYPE_NONE,

--冷却
cool = 0,

--购买价格
gold = 1000,

--物品技能
is_skill = true,

}

function mt:on_cast_start()
    print('施法-随机物品',self.name)
    local hero = self.owner
    local cre_gold = 1000
    local shop_item = ac.item.shop_item_map[self.name]
    if not hero.buy_cnt then 
        hero.buy_cnt = 1
    end    
    --可能会异步
    if hero:get_owner() == ac.player.self then 
        --改变商店物品物价
        shop_item.gold = shop_item.gold + cre_gold
        shop_item:set_tip(shop_item:get_tip())
        
    end     
    hero.buy_cnt = hero.buy_cnt + 1 

    --给英雄随机添加物品
    local rand_list = ac.unit_reward['商店随机物品']
    local rand_name = ac.get_reward_name(rand_list)
    if not rand_name then 
        return
    end    
    
    local list = ac.quality_item[rand_name] 
    --添加 
    local name = list[math.random(#list)]
    --满时，掉在地上
    hero:add_item(name,true)



end

function mt:on_remove()
end