local fresh_time = 10*60 --单位秒

local function fresh_shop_item(shop)
    shop:print_item()
    for i = 9, 11 do 
        --删除商店的物品
        local old_item = shop.sell_item_list[i]
        if old_item then 
            -- print('即将删除商店物品：',old_item.name)
            shop:remove_sell_item(old_item.name)
        end    

        local rand_list = ac.unit_reward['商店随机物品']
        local rand_name = ac.get_reward_name(rand_list)
        if not rand_name then 
            return
        end    
        
        local list = ac.quality_item[rand_name] 
        --添加 
        local name = list[math.random(#list)]
        -- print('即将添加商店物品：',name,i)
        shop:add_sell_item(name,i)
    end   
end    

local function fresh_shop_skill(shop)
    shop:print_item()
    for i = 9, 11 do 
        --删除商店的物品
        local old_item = shop.sell_item_list[i]
        if old_item then 
            -- print('即将删除商店物品：',old_item.name)
            shop:remove_sell_item(old_item.name)
        end    

        local rand_list = ac.unit_reward['商店随机技能']
        local rand_name = ac.get_reward_name(rand_list)
        if not rand_name then 
            return
        end    
        
        local list = ac.skill_list2
        --添加 
        local name = list[math.random(#list)]
        -- print('即将添加商店物品：',name,i)
        shop:add_sell_item(name,i)
    end   
end   

ac.game:event '游戏-开始' (function()
    
    local shop = ac.shop.create('商店A',-600,0)
    ac.loop(fresh_time*1000,function()
        fresh_shop_item(shop)
    end)

    local shop1 = ac.shop.create('商店B',-300,0)
    ac.loop(fresh_time*1000,function()
        fresh_shop_skill(shop1)
    end)

    -- shop:remove_sell_item('新手石')
    -- shop:add_sell_item('错乱精髓',1)
    -- local shop = ac.shop.create('商店B',100,0)
    

end);