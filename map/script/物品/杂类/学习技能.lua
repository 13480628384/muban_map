local mt = ac.skill['学习技能']
--技能模型
mt._model = ac.zb_color_model['绿']
mt.skill_cnt =8 --一共技能数量
function mt:on_cast_shot()
    local hero = self.owner 
    local player = hero:get_owner()
    --宠物也帮忙学技能
    hero = player.hero
    local name = self.skill_name
    if name == nil then 
        return 
    end 

    local skill = hero:find_skill(name,'英雄')

    if skill then 
        local upgrade_count = skill.upgrade_count or 1

        if upgrade_count >= 5 then 
            player:sendMsg('技能已经学满了')

            if self._count > 1 then 
                -- print('数量')
                self:set_item_count(self._count+1)
            else
                --重新添加给英雄
                ac.item.add_skill_item(name,hero)
            end     

            return 
        end 
        upgrade_count = upgrade_count + 1

        skill.upgrade_count = upgrade_count 

        skill:set_level(skill:get_level() + 1)
        -- self:remove()
        return 
    end 

    local count = 0

    local list = {}

    for i=1,self.skill_cnt do 
        local skill = hero:find_skill(i,'英雄')
        if skill then 
            local key = skill:get_hotkey() 
            local info = {
                name = '更换 ' .. skill:get_name() .. ' (' .. key .. ')',
                key = key:byte(),
                skill = skill,
            }
            table.insert(list,info)
        end
    end 
    if #list < self.skill_cnt then 
        hero:add_skill(name,'英雄')
    else 
        local info = {
            name = '取消 (Esc)',
            key = 512
        }
        table.insert(list,info)

        if not self.dialog  then 
            self.dialog = create_dialog(player,'更换技能',list,function (index)
                local skl = list[index].skill
                if skl then 
                    local id = skl.slotid
                    skl:remove()
                    -- self:remove()
                    hero:add_skill(name,'英雄',id)
                else
                    -- print('取消更换技能')
                    if self._count > 1 then 
                        -- print('数量')
                        self:set_item_count(self._count+1)
                    else
                        --重新添加给英雄
                        ac.item.add_skill_item(name,hero)
                    end        
                end
                
                self.dialog = nil
            end)
        else
            self:add_item_count(1)    
        end    
    end 


end 