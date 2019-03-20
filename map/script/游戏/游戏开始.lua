
g_game_min = 1

ac.game:event '游戏-开始' (function()

    ac.loop(60*1000,function()
        g_game_min = g_game_min +1
    end)
    print('游戏开始1')
    --游戏开始，不允许控制中立被动（钥匙怪）
    for x = 0, 10 do
        --不允许控制中立被动的单位
        ac.player.force[1][x]:disableControl(ac.player[16])
        ac.player.force[2][0]:disableControl(ac.player[16])
    end
    print('游戏开始2')
    --每个玩家初始化金币
    for i=1 ,12 do 
        local p = ac.player(i)
        p:addGold(100000)
    end    
    
    -- require '平台.商城'
    local fresh_time = 5*60 --刷新时间
    -- local fresh_time = 10 --刷新时间

    --创建物品商店
    local x,y = ac.map.rects['物品商店']:get_point():get()
    local shop = ac.shop.create('物品商店',x,y)
    ac.map.fresh_shop_item(shop)
    ac.loop(fresh_time*1000,function()
        ac.map.fresh_shop_item(shop)
        ac.player.self:sendMsg('|cff00bdec物品商店|r有新货色来了！赶紧来买！先到先得！',10)
        ac.player.self:sendMsg('|cff00bdec物品商店|r有新货色来了！赶紧来买！先到先得！',10)
        ac.player.self:sendMsg('|cff00bdec物品商店|r有新货色来了！赶紧来买！先到先得！',10)
    end)

    --创建技能商店
    local x,y = ac.map.rects['技能商店']:get_point():get()
    local shop1 = ac.shop.create('技能商店',x,y)
    ac.map.fresh_shop_skill(shop1)
    ac.loop(fresh_time*1000 + 100,function()
        ac.map.fresh_shop_skill(shop1)
        ac.player.self:sendMsg('|cff00ff00技能商店|r有新货色来了！赶紧来买！先到先得！',10)
        ac.player.self:sendMsg('|cff00ff00技能商店|r有新货色来了！赶紧来买！先到先得！',10)
        ac.player.self:sendMsg('|cff00ff00技能商店|r有新货色来了！赶紧来买！先到先得！',10)
    end)

    --创建积分商店
    local x,y = ac.map.rects['积分商店']:get_point():get()
    local shop2 = ac.shop.create('积分商店',x,y+200)
    --创建xx商店
    local x,y = ac.map.rects['XX商店']:get_point():get()
    local shop3 = ac.shop.create('XX商店',x,y)

    -- shop:remove_sell_item('新手石')
    -- shop:add_sell_item('错乱精髓',1)
    -- local shop = ac.shop.create('商店B',100,0)
end)    