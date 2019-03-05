require '物品.装备'
require '物品.消耗品'
require '物品.神符'
require '物品.杂类'
require '物品.寻宝石'
require '物品.商店'
require '物品.合成装备'



--创建技能物品
function ac.item.create_skill_item(name,poi,is)

    local item = ac.item.create_item('学习技能',poi,is)
    -- 技能需要被添加时部分信息才能被调用
    local skill = ac.dummy:add_skill(name,'隐藏')
    local tip = skill:get_simple_tip(ac.dummy,1)
    local art = skill:get_art()
    skill:remove()

    item:set_name(name) 
    item.skill_name = name
    item.tip =  tip .. '|n|cff808080使用即可习得该技能|r' 
    item:set_art(art)
    item:set_tip(item.tip)
    
    -- print(skill.name,item.tip,art,item.art)
	-- if not is then 
	-- 	item._eff = ac.effect(item:get_point(),item._model,270,1,'origin')
    -- end
    
    item.item_type = '消耗品'
    --设置使用次数
    item:set_item_count(1)
    
    return item
    -- item:update()
    -- item:update_ui()
end 

--给英雄添加技能物品
function ac.item.add_skill_item(it,hero)
	if type(it) =='string'  then 	
		it = ac.item.create_skill_item(it,nil,true)
		it:hide()
		it.recycle = true
    end	
    --如果英雄满物品，创建在地上
    hero:add_item(it,true)
    
    return it
end 


