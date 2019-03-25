local mt = ac.skill['传递物品']

mt{
    --必填
    is_skill = true,
    
    --等级
    level = 1,
    --目标类型
    target_type = ac.skill.TARGET_TYPE_UNIT,

    --目标允许
    target_data = '物品',

	tip = [[
传递物品给英雄
	]],
	
	--技能图标
	art = [[icon\jineng037.blp]],

	--cd
	cool = 1,
	
	--施法距离
	range = 99999,
}


function mt:on_add()
	local hero = self.owner 
end	

function mt:on_cast_start()
    local hero = self.owner
	local it = self.target
	print(it)
    -- hero:event_notify('单位-拾取物品',hero,it)
    -- 点太快 重复触发两次拾取。
    if it.owner then 
        print('重复拾取') 
        return
    end    
end

function mt:on_remove()

end
