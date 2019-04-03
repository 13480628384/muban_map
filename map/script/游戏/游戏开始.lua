-- 加载脚本 → 选择难度 → 注册英雄 → 游戏-开始 → 开始刷兵
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
        if p.hero then 
            -- local item = p.hero:add_item('新手礼包') 
            -- local item = p.hero:add_item('迷你熊爪') 
            -- print(item.slot_id,item.type_id,item.name)

        end    
    end    
    
    print('游戏开始12')
    --进行数据统计
    require '游戏.数据统计2'
    print('游戏开始13')



    -- require '平台.商城'
    local fresh_time = 3*60 --刷新时间
    -- local fresh_time = 10 --刷新时间

    --创建物品商店
    local x,y = ac.map.rects['物品商店']:get_point():get()
    local shop = ac.shop.create('物品商店',x,y,270)
    ac.map.fresh_shop_item(shop)
    ac.loop(fresh_time*1000,function()
        ac.map.fresh_shop_item(shop)
        ac.player.self:sendMsg('|cff00bdec物品商店|r有新货色来了！赶紧来买！先到先得！',10)
        ac.player.self:sendMsg('|cff00bdec物品商店|r有新货色来了！赶紧来买！先到先得！',10)
        ac.player.self:sendMsg('|cff00bdec物品商店|r有新货色来了！赶紧来买！先到先得！',10)
    end)

    --创建技能商店
    local x,y = ac.map.rects['技能商店']:get_point():get()
    local shop1 = ac.shop.create('技能商店',x,y,270)
    ac.map.fresh_shop_skill(shop1)
    ac.loop(fresh_time*1000 + 100,function()
        ac.map.fresh_shop_skill(shop1)
        ac.player.self:sendMsg('|cff00ff00技能商店|r有新货色来了！赶紧来买！先到先得！',10)
        ac.player.self:sendMsg('|cff00ff00技能商店|r有新货色来了！赶紧来买！先到先得！',10)
        ac.player.self:sendMsg('|cff00ff00技能商店|r有新货色来了！赶紧来买！先到先得！',10)
    end)

    --创建积分商店
    local x,y = ac.map.rects['积分商店']:get_point():get()
    local shop2 = ac.shop.create('积分商店',x,y+200,270)
    --创建xx商店
    local x,y = ac.map.rects['图书馆']:get_point():get()
    local shop3 = ac.shop.create('图书馆',x,y,270)

    --创建天结散人
    local x,y = ac.map.rects['物品商店']:get_point():get()
    local shop3 = ac.shop.create('天结散人',x-250,y-250,300)

end)    