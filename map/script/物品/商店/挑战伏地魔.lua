--物品名称
local mt = ac.skill['挑战伏地魔']
mt{
--等久
level = 1,

--图标
art = [[icon\hunqi.blp]],

--颜色
color = '青',

--说明
tip = [[|cff00ffff挑战成功将 霸者之证升级Lvmax
条件:霸者之证lv4的灵魂>=150|r]],

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
    local player = hero.owner
    local shop_item = ac.item.shop_item_map[self.name]
    local item = hero:has_item('霸者之证')
    if item.level == 4 and item:get_item_count() >=150 then 
        -- print('达到条件')
        ac.player.self:sendMsg('|cffff0000伏地魔|r |cff00ffff已出现，请大侠击杀，升级霸者之证|r')   
        --创建伏地魔
        local unit = ac.player.com[2]:create_unit('伏地魔',ac.map.rects['刷怪']:get_point())
        local data = ac.table.UnitData['伏地魔']
        if data.model_size then 
            unit:set_size(data.model_size)
        end   
        --设置搜敌路径
        unit:set_search_range(99999)
        --注册事件
        unit:event '单位-死亡'(function(_,unit,killer) 
            --宠物打死也升级
            for i=1,10 do 
                local hero = ac.player(i).hero
                if hero then 
                    local item = hero:has_item('霸者之证')
                    if item and item.level == 4 and item:get_item_count() >=150 then 
                        -- ac.player.self:sendMsg('|cffff0000伏地魔|r |cff00ffff被击杀|r')  
                        item:set_item_count(1)
                        item:upgrade(1)
                    end
                end
            end    
        end)  


    else
        player:sendMsg('条件不足，无法挑战伏地魔')    
    end    



end

function mt:on_remove()
end