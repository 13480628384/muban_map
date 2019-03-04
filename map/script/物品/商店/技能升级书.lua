local mt = ac.skill['技能升级书']

mt{
    --等久
    level = 1,
    
    --图标
    art = [[ReplaceableTextures\CommandButtons\BTNSnazzyScrollPurple.blp]],
    
    --说明
    tip = [[
用于升级技能
    ]],
    
    --物品类型
    item_type = '消耗品',
    
    --目标类型
    target_type = ac.skill.TARGET_TYPE_NONE,
    
    --物品技能
    is_skill = true,
    
}
    
function mt:on_add()
    self.first_use =true
end
function mt:on_cast_start()
    local hero = self.owner
    local player = hero:get_owner()
    local item = self 
    local list = {}
    for skill in hero:each_skill '英雄' do 

        local upgrade_count = skill.upgrade_count or 1
        if upgrade_count < 5  then 
            local price = upgrade_count * 500
            local info = {
                name = skill:get_name() .. ' ' .. (skill:get_level() + 1) .. ' 级 (' .. skill:get_hotkey() ..')' ,
                key = skill:get_hotkey():byte(),
                skill = skill,
            }
            table.insert(list,info)
        end 
    end 

    if #list == 0 then
        player:sendMsg("没有可以升级的技能。")

        if self._count > 1 then 
            self:set_item_count(self._count+1)
        else
            --重新添加给英雄
            ac.item.add_skill_item(name,hero)
        end   

        return
    end 
    local info = {
        name = '取消 (Esc)',
        key = 512
    }
    table.insert(list,info)
    
    if not self.dialog  then 
        self.dialog = create_dialog(player,'选择你要升级的技能',list,
        function (index)
            self.dialog = nil
            local skill = list[index].skill
            if skill then 
                local upgrade_count = skill.upgrade_count or 1
                skill:set_level(skill:get_level() + 1)
                skill.upgrade_count = (upgrade_count + 1)
                if self._count > 0 then  
                    self:on_cast_start()
                    self:add_item_count(-1)
                end    
            else
                self:add_item_count(1)       
            end 
        end)
    else
        self:add_item_count(1)    
    end    

end 
