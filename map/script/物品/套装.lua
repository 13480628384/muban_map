

--套装
local item ={}
item.suit_type = '召唤'

ac.item.suit = {
    --套装名，套装要求类型，符合类型个数及对应加成属性，符合类型个数及对应加成属性
    {'召唤师的赠礼','召唤','2 召唤物+1','3 召唤物+1 召唤物属性+50% ' },
    {'法师的赠礼','法师','3 召唤物+1','5 召唤物+1 召唤物属性+50%' },
    {'战士的赠礼','战士','3 召唤物+1','5 召唤物+1 召唤物属性+50%' },
    {'射手的赠礼','射手','3 召唤物+1','5 召唤物+1 召唤物属性+50%' },
    {'不死的赠礼','不死','3 召唤物+1','5 召唤物+1 召唤物属性+50%' },
}
local function get_suit_count(unit,suit_type)
    local cnt =0 
    for i=1,6 do
        local items = unit:get_slot_item(i)
        if items and items.suit_type == suit_type then
            cnt = cnt + 1
        end
    end
    return cnt 
end    
local function fresh_suit_tip(unit,type,tip)
--刷新单位身上的所有物品说明
    for i =1,6 do 
        -- print(tip)
        local items = unit:get_slot_item(i)
        if items and type == items.suit_type  then
            items:set_tip(items:get_tip()..tip)
        end
    end    
end    

local function unit_add_suit(unit,item)
    if not item.suit_type then 
        return
    end    

    for _, data in ipairs(ac.item.suit) do
        local name, type,attr1,attr2,attr3,attr4,attr5,attr6 = table.unpack(data)
        local temp_attr ={}
        temp_attr[1] = attr1 
        temp_attr[2] = attr2 
        temp_attr[3] = attr3 
        temp_attr[4] = attr4 
        temp_attr[5] = attr5 
        temp_attr[6] = attr6 

        if type == item.suit_type then 
            local tip = '' 
            local unit_suit_cnt = get_suit_count(unit,item.suit_type) or 0 
            tip = tip ..'|cffAAAAAA'.. name..' (已拥有|r|cffffffff'..unit_suit_cnt..'|r|cffAAAAAA) |r'..'\n'
            item.suit_name = name
            for i = 1,6 do
                if temp_attr[i] then 
                    local dest_rate 
                    local t_attr = {} 
                    -- 匹配 召唤物+1   (%S+)%+(%d+%s-)
                    local first_flag = true
                    local active_flag = false
                    local cnt = 0
                    local attr_tip =''
                    for value in temp_attr[i]:gmatch '%S+' do
                        if first_flag  then 
                            -- print(value)
                            first_flag=false
                            cnt = tonumber(value)
                        else
                            -- print(value)
                            attr_tip = attr_tip.. value ..' '
                        end    
                    end

                    --如果满足条件就增加属性
                    if not unit.suit  then 
                        unit.suit ={}
                    end
                    if not unit.suit[name] then 
                        unit.suit[name]={}
                    end
                    if not unit.suit[name][cnt] then 
                        unit.suit[name][cnt]={}
                        unit.suit[name][cnt][1] = false
                        unit.suit[name][cnt][2] = type
                        unit.suit[name][cnt][3] = attr_tip
                    end
                    if unit_suit_cnt >= cnt   then 
                        active_flag = true
                        if not unit.suit[name][cnt][1]  then   
                            for k,v in attr_tip:gmatch '(%S+)%+(%d+%s-)' do
                                --额外增加人物属性
                                --多个物品会额外增加套装属性
                                -- print(attr_tip,k,v)
                                unit:add(k,v)
                            end   
                        end   
                        unit.suit[name][cnt][1] = true
                    end    
                    if active_flag then 
                        tip = tip..'|cff00FF00'..attr_tip..' ('..cnt..')|r\n'
                    else
                        tip = tip..attr_tip..'('..cnt..')\n'
                    end    
                    unit.suit[name][cnt][4] = tip  
                end
            end     
            --刷新单位身上的所有物品说明
            fresh_suit_tip(unit,type,tip)
        end    
    end    

end     

local function unit_remove_suit(unit,item)
    if not unit.suit or not item.suit_type or not item.suit_name  then 
        return
    end    
    local tip = ''
    -- unit.suit[]
    --只需要减属性即可
    local suit_count = get_suit_count(unit,item.suit_type)
    local name = item.suit_name 
   
    tip = tip ..'|cffAAAAAA'.. name..' (已拥有|r|cffffffff'..suit_cnt..'|r|cffAAAAAA) |r'..'\n'
    -- print(tip)
    --刷新tip
                 
    for k,v in pairs(unit.suit) do 
        for i = 1,6 do 
            if v[i] then 
                --如果类型一样且已激活
                if v[i][1] and v[i][2] == item.suit_type and suit_count < i then 
                    --减属性
                    for k,v in v[i][3]:gmatch '(%S+)%+(%d+%s-)' do
                        --额外增加人物属性
                        --多个物品会额外增加套装属性
                        unit:add(k,-v)
                    end
                    v[i][1] = false
                end   
                if v[i][1] then 
                    tip = tip..'|cff00FF00'..v[i][3]..' ('..i..')|r\n'
                else
                    tip = tip..v[i][3]..'('..i..')\n'
                end    
            end 
        end 
    end 
    --刷新 套装说明 移除时的套装变色说明未解决
    fresh_suit_tip(unit,item.suit_type,tip)

end    


ac.game:event '单位-获得物品后' (function (_,unit,item)
    unit_add_suit(unit,item)
end)

ac.game:event '单位-丢弃物品后' (function (_,unit,item)
    --需要移除属性
    --移除激活标志
    unit_remove_suit(unit,item)
end)

