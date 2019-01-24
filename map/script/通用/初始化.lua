    ac.item_list = {}
    ac.shop_item_list = {}
    --物品列表
    for i=10,999 do
        local id = 'I'
        if i<=100 then
            id = id .. '0'..i
        else
            id = id..i
        end
        ac.item_list[i-9] = id
    end

    --商店物品列表 全部使用神符类物品
    for i=10,500 do
        local id = 'S'
        if i < 100 then
            id = id..'0'..i
        else
            id=id..i
        end
        ac.shop_item_list[i-9] = id
    end


	--获取一个句柄 - 商店
	function ac.get_shop_item_handle()
		local id = ac.shop_item_list[#ac.shop_item_list]
		if not id then
			print('物品句柄上限')
			return
		end

		table.remove(ac.shop_item_list)
		return id
	end