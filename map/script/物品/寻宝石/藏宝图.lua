local mt = ac.skill['藏宝图']

mt{
    --等久
    level = 1,
    
    --图标
    art = [[other\cangbaotu.blp]],
    
    --说明
    tip = [[到指定地点，挖开即可得 |cffdf19d0 各种物品哦 |r]],
    
    --物品类型
    item_type = '消耗品',
    
    --目标类型
    target_type = ac.skill.TARGET_TYPE_NONE,
    
    --物品技能
    is_skill = true,
    --挖图范围
    area = 500,

    --售价
    gold = 250,
    --物品详细介绍的title
    content_tip = '使用说明：'
    
}
    
function mt:on_add()
    --全图随机刷 正式用
    self.random_point =  ac.map.rects['刷怪']:get_point()
    --测试用
    -- self.random_point = self.owner:get_point()
end

-- ac.game:event '单位-点击商店物品'(function(_,seller,u,it)
--     if it.name ~= mt.name then 
--         return 
--     end   
--     local item = u:has_item(mt.name)
--     local player = u:get_owner()
--     if item and item:get_item_count() >= 10 then 
--         player:sendMsg('藏宝图数量不能大于10个，请挖完后再来补充')
--         return 
--     end    
    
-- end)
function mt:on_cast_start()
    local hero = self.owner
    local player = hero:get_owner()
    local item = self 
    local list = {}
    --需要先增加一个，否则消耗品点击则无条件先消耗
    self:add_item_count(1) 

    local tx,ty = self.random_point:get()
    local rect = ac.rect.create( tx - self.area/2, ty-self.area/2, tx + self.area/2, ty + self.area/2)
    local region = ac.region.create(rect)
    local point = hero:get_point()

    
    --点在区域内
    if region < point  then 

        if hero.unit_type == '宠物' or hero.unit_type == '召唤物' then 
            player:sendMsg('|cff00ffff宠物不能挖图|r',10)
            player:sendMsg('|cff00ffff宠物不能挖图|r',10)
            return true
        end    

        self:add_item_count(-1) 
        self:on_add() 
        --添加东西给英雄
        self:add_content()
    else
        player:pingMinimap(self.random_point, 3)
    end    
end    

function mt:add_content()
    
    local hero = self.owner
    local player = self.owner:get_owner()
    hero = player.hero 
    -- print('使用了命运花')
    local rand_list = ac.unit_reward['藏宝图']
    local rand_name = ac.get_reward_name(rand_list)
    -- print(rand_list,rand_name)
    if not rand_name then 
        return true
    end   

    local index = ac.creep['刷怪'].index or 1
    local data = ac.table.UnitData['进攻怪-'..index]
    local gold = math.ceil( (data.gold or 0) * 10  )
    local exp = math.ceil((data.exp or 0)  * 10 )

    
    if rand_name == '无' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000什么事都没发生|r',10)
    elseif rand_name == '金币10' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000奖励金币：'..gold..'|r',10)
        hero:addGold(gold)
    elseif  rand_name == '经验10' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000奖励经验：'..gold..'|r',10)
        hero:addXp(exp)
    elseif  rand_name == '随机物品' then
         --给英雄随机添加物品
        local rand_list = ac.unit_reward['均分随机物品']
        local rand_name = ac.get_reward_name(rand_list)
        if not rand_name then 
            return
        end    
        local list = ac.quality_item[rand_name] 
        local name = list[math.random(#list)]
        --满时，掉在地上
        hero:add_item(name,true)
        local lni_color ='白'
        if  ac.table.ItemData[name] and ac.table.ItemData[name].color then 
            lni_color = ac.table.ItemData[name].color
        end    
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, 奖励：|cff'..ac.color_code[lni_color]..name..'|r',10)
    elseif  rand_name == '随机技能书' then
        hero:add_item('随机技能书',true)
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000奖励：随机技能书|r',10)
    elseif  rand_name == '召唤boss' then
        hero:add_item('召唤boss',true)
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000奖励：召唤boss|r',10)
    elseif  rand_name == '吞噬丹' then
        hero:add_item('吞噬丹',true)
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000奖励：吞噬丹|r',10)
    elseif  rand_name == '杀怪全属性5' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000杀怪 全属性+5 |r',10)
        hero:add('杀怪全属性',5)
    elseif  rand_name == '全属性加1000' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000全属性加1000 |r',10)
        hero:add('力量',1000)
        hero:add('敏捷',1000)
        hero:add('智力',1000)
    elseif  rand_name == '全属性加10000' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000全属性加10000 |r',10)
        hero:add('力量',10000)
        hero:add('敏捷',10000)
        hero:add('智力',10000)    
    elseif  rand_name == '护甲加50' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000护甲加25 |r',10)
        hero:add('护甲',25)    
    elseif  rand_name == '杀怪力量5' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000杀怪 力量+5 |r',10)
        hero:add('杀怪力量',5)
    elseif  rand_name == '杀怪敏捷5' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000杀怪 敏捷+5 |r',10)
        hero:add('杀怪敏捷',5)
    elseif  rand_name == '杀怪智力5' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000杀怪 智力+5 |r',10)
        hero:add('杀怪智力',5)
    elseif  rand_name == '通关积分25' then
        ac.player.self:sendMsg('玩家 |cff00ffff'..player:get_name()..'|r 挖了|cff00ffff藏宝图|r, |cffff0000 通关积分+25 |r',10)
        if ac.jiami then 
            ac.jiami(player,'jifen',25)
        end    
    end
   

end

function mt:on_remove()

end