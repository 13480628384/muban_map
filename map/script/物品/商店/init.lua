require '物品.商店.随机4个物品和技能'
require '物品.商店.随机物品'
require '物品.商店.随机物品2'
require '物品.商店.随机技能'
require '物品.商店.随机技能1'
require '物品.商店.随机技能2'
require '物品.商店.技能升级书'
require '物品.商店.技能升级书1'
require '物品.商店.霸者之证进阶'
require '物品.商店.挑战伏地魔'
require '物品.商店.迷路的坦克'


--一开始就创建商店 需要有玩家在视野内 漂浮文字的高度才能显示出来

ac.game:event '玩家-注册英雄后' (function()
    if ac.flag_shop  then return end
    ac.flag_shop = true
    ac.wait(2*1000,function()
        print('注册英雄后1')
        local fresh_time = 2*60 --刷新时间
        if global_test then 
            fresh_time = 10 --测试刷新时间
        end
        local off_set = 0
        --创建物品商店
        local x,y = ac.map.rects['物品商店']:get_point():get()
        local shop = ac.shop.create('物品商店',x,y-off_set,270)
        shop:set_size(1.2)
        ac.map.fresh_shop_item(shop)
        ac.loop(fresh_time*1000,function()
            ac.map.fresh_shop_item(shop)
            ac.player.self:sendMsg('|cff00bdec物品商店|r有新货色来了！赶紧来买！先到先得！',10)
            ac.player.self:sendMsg('|cff00bdec物品商店|r有新货色来了！赶紧来买！先到先得！',10)
            ac.player.self:sendMsg('|cff00bdec物品商店|r有新货色来了！赶紧来买！先到先得！',10)
        end)

        print('注册英雄后2')
        --创建技能商店
        local x,y = ac.map.rects['技能商店']:get_point():get()
        local shop1 = ac.shop.create('技能商店',x,y-off_set,270)
        shop1:set_size(0.7*1.2)
        ac.map.fresh_shop_skill(shop1)
        ac.loop(fresh_time*1000 + 100,function()
            ac.map.fresh_shop_skill(shop1)
            ac.player.self:sendMsg('|cff00ff00技能商店|r有新货色来了！赶紧来买！先到先得！',10)
            ac.player.self:sendMsg('|cff00ff00技能商店|r有新货色来了！赶紧来买！先到先得！',10)
            ac.player.self:sendMsg('|cff00ff00技能商店|r有新货色来了！赶紧来买！先到先得！',10)
        end)

        print('注册英雄后3')
        --创建积分商店
        local x,y = ac.map.rects['积分商店']:get_point():get()
        local shop2 = ac.shop.create('积分商店',x,y-off_set,270)
        shop2:set_size(2*1.2)
        print('注册英雄后4')
        --创建xx商店
        local x,y = ac.map.rects['图书馆']:get_point():get()
        local shop3 = ac.shop.create('图书馆',x,y-off_set,270)
        shop3:set_size(1.2)

        print('注册英雄后5')
        --创建天结散人
        local x,y = ac.map.rects['天结散人']:get_point():get()
        local shop4 = ac.shop.create('天结散人',x,y-off_set,270)
        shop4:set_size(1.2)

        print('注册英雄后6')
        ac.game:event '游戏-回合开始'(function(trg,index, creep) 
            --藏宝图 第10波 出现
            local index = 10 
            if creep.name == '刷怪' and  creep.index == index then
                shop4:add_sell_item('藏宝图',1)
                --发送消息
                ac.player.self:sendMsg('【系统消息】新增|cffff0000藏宝图|r玩法，前往|cffff0000天结散人|r处购买',10)
                ac.player.self:sendMsg('【系统消息】新增|cffff0000藏宝图|r玩法，前往|cffff0000天结散人|r处购买',10)
                ac.player.self:sendMsg('【系统消息】新增|cffff0000藏宝图|r玩法，前往|cffff0000天结散人|r处购买',10)
            end   

            --迷路的宝藏 第20波 出现
            local index = 20 
            if creep.name == '刷怪' and  creep.index == index then
                shop4:add_sell_item('迷路的坦克',2)
                --发送消息
                ac.player.self:sendMsg('【系统消息】新增|cffff0000迷路的坦克|r玩法，前往|cffff0000天结散人|r处购买',10)
                ac.player.self:sendMsg('【系统消息】新增|cffff0000迷路的坦克|r玩法，前往|cffff0000天结散人|r处购买',10)
                ac.player.self:sendMsg('【系统消息】新增|cffff0000迷路的坦克|r玩法，前往|cffff0000天结散人|r处购买',10)
            end   
        end)
    end)    

end)