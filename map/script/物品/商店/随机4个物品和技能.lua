local fresh_time = 10 --单位秒

local function fresh_shop_item(shop)
    for i = 5, 8 do 
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
    --刷新商店物品，先全部删除，再挨个添加
    shop:fresh()

    -- shop:remove_sell_item('账簿')  
    -- shop:remove_sell_item('新手戒指')  
    -- shop:remove_sell_item('新手弓')  
    -- shop:add_sell_item('新手戒指',9)  
    -- shop:add_sell_item('新手戒指',10)  
    -- shop:add_sell_item('新手弓',11)  
    --================以下为测试代码==================
    --从商店移除
    -- jass.RemoveItemFromStock(shop.handle,base.string2id("S009"))
    -- jass.RemoveItemFromStock(shop.handle,base.string2id("S00A"))
    -- jass.RemoveItemFromStock(shop.handle,base.string2id("S00B"))

    -- --添加到商店
	-- jass.AddItemToStock(shop.handle,base.string2id("S009"),1,1)
	-- jass.AddItemToStock(shop.handle,base.string2id("S00A"),1,1)
	-- jass.AddItemToStock(shop.handle,base.string2id("S00B"),1,1)
end    

local function fresh_shop_skill(shop)
    for i = 5, 8 do 
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
end   

ac.game:event '游戏-开始' (function()
    
    local shop = ac.shop.create('物品商店',-500,300)
    -- 添加到商店
	-- jass.AddItemToStock(shop.handle,base.string2id("S009"),1,1)
	-- jass.AddItemToStock(shop.handle,base.string2id("S00A"),1,1)
	-- jass.AddItemToStock(shop.handle,base.string2id("S00B"),1,1)
    ac.loop(fresh_time*1000,function()
        fresh_shop_item(shop)
    end)

    local shop1 = ac.shop.create('技能商店',500,300)
    ac.loop(fresh_time*1000 + 100,function()
        fresh_shop_skill(shop1)
    end)

    local shop2 = ac.shop.create('积分商店',-500,-300)
    local shop3 = ac.shop.create('XX商店',500,-300)
    -- shop:remove_sell_item('新手石')
    -- shop:add_sell_item('错乱精髓',1)
    -- local shop = ac.shop.create('商店B',100,0)
    

end);