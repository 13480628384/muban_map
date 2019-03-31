--物品名称
local mt = ac.skill['飞升']
mt{
--等久
level = 1,

--图标
art = [[icon\feisheng.blp]],
--颜色
color = '青',

--说明
tip = [[|cff00ffff当达到了一定的修为后，如果想在修为上更进一步，只有拥有霸者之证的人，才能步入化境！
条件1：英雄达到100级
条件2：拥有霸者之证
飞升属性1：英雄杀怪增加5点全属性
飞升属性2：使得霸者之证通灵，杀死敌人有概率（15%）可收集灵魂（受物品获取率影响））|r]],

--物品类型
item_type = '神符',

--目标类型
target_type = ac.skill.TARGET_TYPE_NONE,

--冷却
cool = 0,

--物品技能
is_skill = true,
--商店名词缀
store_affix = ''
}

function mt:on_cast_start()
    local hero = self.owner
    local player = hero:get_owner()
    local shop_item = ac.item.shop_item_map[self.name]
    local item = hero:has_item('霸者之证')
    if hero.level == 100 and item then 
        --物品进化
        item:upgrade(1)
        ac.player.self:sendMsg('恭喜|cffff0000'..player:get_name()..'|r |cff00ffff飞升成功，霸者之证获得进化能力|r')   
    else
        player:sendMsg('|cff00ffff条件不足，飞升失败|r')    
    end    

end

function mt:on_remove()
end