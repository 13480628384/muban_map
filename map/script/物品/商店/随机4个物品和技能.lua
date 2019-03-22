

local function fresh_shop_item(shop)
    for i = 9, 12 do 
        local rand_list = ac.unit_reward['商店随机物品']
        local rand_name = ac.get_reward_name(rand_list)
        if not rand_name then 
            return
        end    
        
        local list = ac.quality_item[rand_name] 
        --添加 
        local name = list[math.random(#list)]
        shop.sell[i] = name
        shop.sell_new_gold[i] = true
        -- shop:add_sell_item(name,i)
    end 
    shop.sell[5] = '翔龙'
    --刷新商店物品，先全部删除，再挨个添加
    shop:fresh()

    --再循环一次，添加物品被购买时移除的触发。
    for i = 9, 12 do 
        local old_item = shop.sell_item_list[i]
        old_item.on_selled_remove = true 
    end    

end    

local function fresh_shop_skill(shop)
    for i = 9, 12 do 
        --删除商店的物品
        -- local old_item = shop.sell_item_list[i]
        -- if old_item then 
        --     -- print('即将删除商店技能：',old_item.name)
        --     shop:remove_sell_item(old_item.name)
        -- end    

        local rand_list = ac.unit_reward['商店随机技能']
        local rand_name = ac.get_reward_name(rand_list)
        if not rand_name then 
            return
        end    
        
        local list = ac.skill_list2
        --添加 
        local name = list[math.random(#list)]
        -- print('即将添加商店物品：',name,i)
        -- shop:add_sell_item(name,i)
        shop.sell[i] = name
        shop.sell_new_gold[i] = true
        
    end   
    --刷新商店物品，先全部删除，再挨个添加
    shop:fresh()
    --再循环一次，添加物品被购买时移除的触发。
    for i = 9, 12 do 
        local old_item = shop.sell_item_list[i]
        old_item.on_selled_remove = true 
    end    
end   
ac.map.fresh_shop_skill = fresh_shop_skill
ac.map.fresh_shop_item = fresh_shop_item