local quality_item ={}

-- for name,data in pairs(ac.table.item) do 
--     local color = data.color 
--     if data.item_type == '装备' and color then 
--         if color then 
--             local list = equipments[color] or {}
--             equipments[color] = list 

--             table.insert(list,name)
--         end 
--     end 
-- end 


local streng_item_list = {
    {'新手剑+1','新手剑*1 新手石*1'},
    {'新手剑+2','新手剑+1*1 新手石*1'},
    {'灵宝剑','新手剑+2*1 新手甲*1 新手戒指*1'},
    {'新手剑+1','生命药水*5 新手石*1'},
    {'新手剑+2','生命药水*5 魔法药水*5'},

}
local function streng_item(alltable,unit,it)

    local u = unit
    local p = unit:get_owner()


    local hebing 
    local trg_it = it 
    --将当前即将获得的物品放入到表里
    --强化石的石头返回数量有点问题，需要调整下。
    local function new_item_table() 

        local unit_item_list = {}
        for i = 1,6 do

            local item = u:get_slot_item(i)

            if  item then 
                local temp_item = {}
                temp_item[item.name] = item:get_item_count()

                if  item.name == trg_it.name and trg_it.item_type == '消耗品' then
                    temp_item[item.name] = temp_item[item.name] + trg_it:get_item_count()
                    hebing =true
                end    

                table.insert(unit_item_list,temp_item)
            end   
        end    

        if not hebing then
            local temp_item = {}
            temp_item[trg_it.name] = trg_it:get_item_count()
            table.insert(unit_item_list,temp_item)
        end     
        return unit_item_list
    end    

    --string ,返回的是 该装备数量
    local function find_item (table,it_name)  

        local stack 
        for i=1,#table do
            for key,val in pairs(table[i]) do 
                if key == it_name then
                    stack = val
                    break
                end    
            end    
        end   

        return stack
    end  


    for _, data in ipairs(alltable) do
        local dest_str, source_str = table.unpack(data)
        
        local source_names = {}
        local max_cnt = 0
        for k,v in source_str:gmatch '(%S+)%*(%d+%s-)' do
            source_names[k]=v
            max_cnt = max_cnt +1
        end
        local is_streng_suc =false 
        local i = 0
   
        local is_block_trg_item
        local unit_item_list = new_item_table() 

        for k,v in pairs(source_names) do
 
            local stack = find_item(unit_item_list,k)
            if not stack then
                is_streng_suc =false 
                -- print('合成失败，没有',k)    
                break
            end    
            
            if stack == 0 or stack == 1 then
                stack = 1
            end    
            -- print(k,stack,v)

            if stack >= tonumber(v) then
                -- print('有这个'..k..',且数量正确')
                -- print('合成条件数',i,max_cnt)
                i = i + 1 
                if  i == max_cnt then
                    is_streng_suc = true
                end    
            end
        end    

        -- 如果合成成功，移除材料，添加新物品
        -- 合成一次就退出，移除材料的同时，要阻止获得材料。
        if is_streng_suc then 
            print('合成'..dest_str..'成功')
            for k,v in pairs(source_names) do
                local u_it = u:has_item(k)
                --即将获得的物品
                if k == trg_it.name  then 
                    --删除即将获得物品
                    trg_it:item_remove() 
                    --不获得即将获得的物品 
                    is_block_trg_item = true
                    
                else
                    --不是即将获得的物品，就删掉单位身上的
                    if u_it then 
                        u:remove_item(u_it)
                    end     
                    
                end    

                if trg_it.item_type =='消耗品' or (u_it and u_it.item_type =='消耗品') then
                    --如果即将获得的物品时消耗品，先删除单位身上的物品
                    if u_it and u_it.item_type =='消耗品' then 
                        --需要再重新找一遍，看这个物品是否被删了。
                        local u_it = u:has_item(k)
                        if u_it then
                             u:remove_item(u_it)
                        end     
                    end   
                    
                    --创建新的物品，并设置物品数量为 总数量-合成需要的数量
                    local stack = find_item(unit_item_list,k)
                    if stack -  tonumber(v) > 0 then 
                        local new_it = ac.item.create_item(k)
                        new_it:set_item_count( stack -  tonumber(v))
                        u:add_item(new_it,true)
                    end  

                end   

                
            end

            p:sendMsg('合成'..dest_str..'成功')
            local new_item = u:add_item(dest_str,true)  

            -- 新物品 ， 材料列表 k = 材料名 ，v =数量
            -- 回调时 需要等 合成物品成功，程序继续进行
            ac.game:event_dispatch('物品-合成成功',new_item,source_names) 
              
            return is_block_trg_item 
        end    

    end    
    return is_block_trg_item
end    

ac.game:event '单位-即将获得物品前' (function(trg, unit, it)

    -- print(it.name,it.removed,it.unique,unit:has_item(it.name))
    --合成装备
    -- print('合成装备')
     local is_block_trg_item = streng_item(streng_item_list,unit,it)
     return is_block_trg_item

    --ac.game:event_dispatch('物品-合成成功',new_item,source_names)  
    
    
end)
ac.game:event '物品-合成成功' (function(trg, new_item, source_names) 
    if not new_item then 
        return
    end    
    local name = new_item:get_name()
    if name =='灵宝剑' then
        print('合成灵宝剑')
    end    
    return true 
end)


