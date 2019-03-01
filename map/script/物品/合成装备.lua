--按照装备品阶 筛选出 lni 装备。
--quality_item={'白' = {'新手剑','新手戒指'},'蓝' = {..}}
local quality_item ={}
for name,data in pairs(ac.table.ItemData) do 
    local color = data.color 
    if color then 
        local list = quality_item[color] or {}
        quality_item[color] = list 
        table.insert(list,name)
    end 
end 
-- for k,v in pairs(quality_item) do
--     print(k,v[1])
-- end
-- local dest_str = '蓝'
-- print('蓝色随机装备:',quality_item[dest_str][math.random(1,#quality_item[dest_str])])



local streng_item_list = {
   
    -- {'新手剑+1','新手剑*1 新手石*1'},
    -- {'新手剑+2','新手剑+1*1 新手石*1'},
    -- -- {'灵宝剑','新手剑+2*1 新手甲*1 新手戒指*1'},
    -- {'灵宝剑','新手剑+2*1 新手剑+2*1 新手剑+2*1'},
    -- {'新手剑+1','生命药水*5 新手石*1'},
    -- {'新手剑+2','生命药水*5 魔法药水*5'},
    --合成品质为消耗品会出错 ^10 表示10%几率合成
    {'蓝^25','白*1 白*1 白*1 白*1 装备合成书*1'},
    {'金^25','蓝*1 蓝*1 蓝*1 蓝*1 装备合成书*1'},
    {'红^25','金*1 金*1 金*1 金*1 装备合成书*1'}

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
                temp_item.name = item.name
                temp_item.value = item:get_item_count()
                temp_item.is_finded = false 

                if  item.name == trg_it.name and trg_it.item_type == '消耗品' then
                    temp_item.value = temp_item.value + trg_it:get_item_count()
                    hebing =true
                end    

                table.insert(unit_item_list,temp_item)
                --处理品质装备 消耗品不能合
                local temp_item = {}
                temp_item.name = item.color 
                temp_item.item_name = item.name
                temp_item.value = item:get_item_count()
                temp_item.is_finded = false 
                table.insert(unit_item_list,temp_item)

            end   
        end    

        if not hebing then
            local temp_item = {}
            temp_item.name = trg_it.name
            temp_item.value = trg_it:get_item_count()
            temp_item.is_finded = false 

            table.insert(unit_item_list,temp_item)
            --处理品质装备
            local temp_item = {}
            temp_item.name = trg_it.color 
            temp_item.item_name = trg_it.name
            temp_item.value = trg_it:get_item_count()
            temp_item.is_finded = false 
            table.insert(unit_item_list,temp_item)
        end     
        return unit_item_list
    end    

    --string ,返回的是 该装备数量,is_finded true 找已经找过的，false 找没有找过的
    local function find_item (table,it_name,is_finded)  

        local stack 
        -- print(table[i]['is_finded'])
        for i=1,#table do
            if table[i]['name'] == it_name and table[i]['is_finded'] == is_finded  then 
                stack = table[i]['value']
                table[i]['is_finded'] = true 
                if table[i].item_name then 
                    find_item(table,table[i].item_name,false)
                end    
                break
            end    
        end   
        return stack
    end  
    local function print_item (table)  
        local pt = ''
        for i=1,#table do
            if table[i]['name'] and table[i]['name'] ~='白' then
                pt = pt ..table[i]['name']  ..table[i]['value'] .. ','
            end    
        end
        print(pt)
    end    

    for _, data in ipairs(alltable) do
        local dest_str, source_str = table.unpack(data)
        local dest_rate 
        for k,v in dest_str:gmatch '(%S+)%^(%d+%s-)' do
            dest_str = k
            dest_rate = v
        end    

        local source_names = {}
        local max_cnt = 0
        for k,v in source_str:gmatch '(%S+)%*(%d+%s-)' do
            local temp_array = {} 
            temp_array[k]=v
            table.insert(source_names,temp_array)
            max_cnt = max_cnt +1
        end
        local is_streng_suc =false 
        local i = 0
   
        local is_block_trg_item
        local unit_item_list = new_item_table()   

        for ti=1,max_cnt do 
            -- print(source_names[ti])   
            for k,v in pairs(source_names[ti]) do
                local stack = find_item(unit_item_list,k,false)
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
                    -- print('合成条件数',i,max_cnt)
                    i = i + 1 
                    if  i == max_cnt then
                        is_streng_suc = true
                    end    
                end
            end    
        end 
        -- 如果合成成功，移除材料，添加新物品
        -- 合成一次就退出，移除材料的同时，要阻止获得材料。
        -- 物品合成有问题，要先全部删掉，
        if is_streng_suc then 
            -- print('合成'..dest_str..'成功')
            -- print_item(unit_item_list)
            local del_item ={} 
            for ti=1,max_cnt do 
                for k,v in pairs(source_names[ti]) do
                    local u_it = u:has_item(k) 
                    
                    --不是即将获得的物品，就删掉单位身上的
                    if u_it then 
                        table.insert(del_item,u_it)
                        u:remove_item(u_it)
                    else   
                        if k == trg_it.name or k == trg_it.color  then 
                            
                            table.insert(del_item,trg_it)
                            if trg_it.handle then  
                                --删除即将获得物品
                                trg_it:item_remove() 
                                --不获得即将获得的物品 
                                is_block_trg_item = true
                            end    
                        end     
                    end    

                    if (trg_it and (trg_it.name ==k ) and trg_it.item_type =='消耗品') or (u_it and (u_it.name == k )  and  u_it.item_type =='消耗品') then
                        if trg_it.handle then 
                            table.insert(del_item,trg_it)
                            --删除即将获得物品
                            trg_it:item_remove() 
                            --不获得即将获得的物品 
                            is_block_trg_item = true
                        end    
                        --如果即将获得的物品时消耗品，先删除单位身上的物品
                        if u_it and u_it.item_type =='消耗品' then 
                            --需要再重新找一遍，看这个物品是否被删了。
                            local u_it = u:has_item(k)
                            if u_it then
                                table.insert(del_item,u_it)
                                u:remove_item(u_it)
                            end     
                        end   
                        
                        --创建新的物品，并设置物品数量为 总数量-合成需要的数量
                        --已经找过的
                        --等待0.10秒，等全部物品都删了后，再添加
                        ac.wait(10,function()
                            local stack = find_item(unit_item_list,k,true)
                            if stack -  tonumber(v) > 0 then 
                                local new_it = ac.item.create_item(k)
                                new_it:set_item_count( stack -  tonumber(v))
                                u:add_item(new_it,true)
                            end  
                        end)

                    end   
                    local name
                    if (trg_it and trg_it.color == k and trg_it.item_type =='消耗品') then 
                        name = trg_it.name 
                    end

                    if (u_it and u_it.color ==k and u_it.item_type =='消耗品') then 
                        name = u_it.name 
                    end    

                    if name then
                        -- print(name)
                        ac.wait(10,function()
                            local stack = find_item(unit_item_list,name,true)
                            -- print_item(unit_item_list)
                            if stack -  tonumber(v) > 0 then 
                                local new_it = ac.item.create_item(name)
                                new_it:set_item_count( stack -  tonumber(v))
                                u:add_item(new_it,true)
                            end  
                        end)
                    end    
                end
            end
            -- 品质装备的 取物品名字
            if not ac.table.ItemData[dest_str] then 
                dest_str = quality_item[dest_str][math.random(1,#quality_item[dest_str])]
                local max_strong_rate = 0 
                local temp_rate 
                --处理同名装备提升合成成功概率
                for x=1,#del_item do
                    temp_rate = 0
                    for y=1,#del_item do
                        if x ~= y and del_item[x].name == del_item[y].name  then
                            temp_rate = temp_rate+1
                            if max_strong_rate<=temp_rate then
                                max_strong_rate = temp_rate
                            end 
                        end
                    end    
                end    
                print('提升概率：',max_strong_rate)
                if dest_rate then 
                    dest_rate = dest_rate + 25 * max_strong_rate
                end 
            end    
            

            -- ac.game:event_dispatch('物品-合成成功前', dest_str,source_names,del_item) 
            -- print('最终概率',dest_rate)
            if math.random(1,100) <= (tonumber(dest_rate) or 100) then 
                p:sendMsg('合成'..dest_str..'成功')
                local new_item  = u:add_item(dest_str,true)  
                -- 新物品 ， 材料列表 k = 材料名 ，v =数量
                -- 回调时 需要等 合成物品成功，程序继续进行
                ac.game:event_dispatch('物品-合成成功',new_item,source_names) 
            else
                p:sendMsg('合成'..dest_str..'失败')
                ac.game:event_dispatch('物品-合成失败',dest_str,source_names) 
            end    
              
            return is_block_trg_item 
        end    

    end    
    return is_block_trg_item
end    

ac.game:event '单位-合成装备' (function(trg, unit, it)

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



