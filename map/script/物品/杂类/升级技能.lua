local mt = ac.item['升级技能']


function mt:on_add()
    local hero = self.owner
    local player = hero:get_owner()
    local item = self 
    local list = {}
    local count = 0 
    for skill in hero:each_skill '英雄' do 

        local upgrade_count = skill.upgrade_count or 1
        if upgrade_count < 5 and skill.card_level and skill.card_level <= 4 then 
            local price = upgrade_count * 500
            local info = {
                name = skill:get_name() .. ' ' .. (skill:get_level() + 1) .. ' 级 价格 ' .. price ..'(' .. skill:get_hotkey() ..')' ,
                key = skill:get_hotkey():byte(),
                skill = skill,
            }
            table.insert(list,info)
        end 
    end 
    self:remove()
    if #list == 0 then
        player:sendMsg("没有可以升级的技能。")
        return
    end 
    local info = {
        name = '取消 (Esc)',
        key = 512
    }
    table.insert(list,info)
    create_dialog(player,'选择你要升级的技能',list,
    function (index)
        local skill = list[index].skill
        if skill then 
            local upgrade_count = skill.upgrade_count or 1
            local price = upgrade_count * 500
            local gold = player:getGold()
            if gold < price then 
                player:sendMsg("钱不够，升级失败")
                return 
            end 
            player:addGold(-price)
            skill:set_level(skill:get_level() + 1)
            skill.upgrade_count = (upgrade_count + 1)
        end 
    end)
end 