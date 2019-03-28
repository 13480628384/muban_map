--物品名称
--随机技能添加给英雄貌似有点问题。
local mt = ac.skill['吞噬丹']
mt{
--等久
level = 1,

--冷却
cool = 0,

--物品技能
is_skill = true,

}

function mt:on_cast_start()
    local hero = self.owner
    local player = hero:get_owner()
    local count = 0
    local name = self:get_name()

    local list = {}

    for i=1,6 do 
        local item = hero:get_slot_item(i)
        if item and item.item_type == '装备' then 
            count = count + 1
            local info = {
                name = "|cff"..ac.color_code[item.color or '白']..'吞噬'.. item:get_name() .. '|r  (第' .. item.slot_id .. '格)',
                item = item
            }
            table.insert(list,info)
        end
    end 
    if count < 1 then 
        player:sendMsg('没有可吞噬的装备')
        if self._count > 1 then 
            -- print('数量')
            self:set_item_count(self._count+1)
        else
            --重新添加给英雄
            hero:add_item(name,true)
        end     
        return 
    end 
    local info = {
        name = '取消 (Esc)',
        key = 512
    }
    table.insert(list,info)

    if not self.dialog  then 
        self.dialog = create_dialog(player,'吞噬装备',list,function (index)
            local item = list[index].item
            if item then 
                --宠物吞噬自己身上的装备，给英雄加属性
                -- item.owner = hero:get_owner().hero
                --再加一次属性
                item:on_add_state()
                --移除装备，移除一次属性
                item:item_remove()
            else
                -- print('取消更换技能')
                if self._count > 1 then 
                    -- print('数量')
                    self:set_item_count(self._count+1)
                else
                    --重新添加给英雄
                    hero:add_item(name,true)
                end        
            end
            
            self.dialog = nil
        end)
    else
        self:add_item_count(1)    
    end    


end

function mt:on_remove()
end