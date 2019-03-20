local jass = require 'jass.common'
local unit = require 'types.unit'

local shop = {}
local mt = {}
ac.shop = shop

shop.__index = mt
setmetatable(mt, unit)

--保存商店NPC
shop.unit_list = {}

--类型
mt.unit_type = 'shop'

--页面记录
mt.page_stack = nil

--文字显示
local function on_texttag(string,hero)
	local target = hero
	local x, y = target:get_point():get()
	local z = target:get_point():getZ()
	local tag = ac.texttag
	{
		string = string,
		size = 16,
		position = ac.point(x-100 , y, z + 200),
		red = 238,
		green = 31,
		blue = 39,
		permanent = true,
		time = ac.clock(),
	}
	return tag
end
--创建一个商店
function shop.create(name,x,y,face,is_selling)
	local unit = ac.player[11]:create_unit(name,ac.point(x,y),face)
	unit:add_restriction '无敌'
	unit:add_restriction '缴械'
	--继承商店
	setmetatable(unit, shop)
	if not unit.sell then 
		unit.sell = {}
	end	
	if not unit.sell_new_gold then 
		unit.sell_new_gold = {}
	end	

	if not is_selling then 
		local data = ac.table.UnitData[name]
		local sell = data.sell
		unit.sell = sell
		if sell then 
			for i,v in ipairs(sell) do
				unit:add_sell_item(v,i)
			end
		end	
	end	
	--创建文字
	unit.texttag = on_texttag(name,unit)

	shop.unit_list[unit.handle] = unit

	local j_trg = war3.CreateTrigger(function()
		--贩卖者
		local seller = shop.unit_list[jass.GetSellingUnit()]
		--购买者
		local u = ac.unit.j_unit(jass.GetBuyingUnit())
		-- 被购买的物品名，没办法保存物品handle，因为物品添加给商店时就被删除了
		-- 添加颜色代码会导致物品没有在商店里面创建。
		local it_name = jass.GetItemName(jass.GetSoldItem())
		-- 如果英雄在两个商店的中间，购买一次物品会触发两次购买事件。
		if not it_name then 
			return
		end	
		it_name = clean_color(it_name)
		local it = ac.item.shop_item_map[it_name]

		--删掉物品排泄(神符类物品需要删除)
		jass.RemoveItem(jass.GetSoldItem())

		if not u or not seller or not it then
			return
		end

		u:event_notify('单位-点击商店物品',seller,u,it)
	end)

	for i = 1, 13 do
		jass.TriggerRegisterPlayerUnitEvent(j_trg, ac.player[i].handle, jass.EVENT_PLAYER_UNIT_SELL_ITEM, nil)
	end

	return unit
end

--移除时的处理
function mt:on_remove()
	--全部删除
	self:remove_all()
	--移除文字显示
	if self.texttag then 
		self.texttag:remove()
	end	
end	
--打印商品
function mt:print_item()
	local str =""
	if not next(self.sell_item_list)  then 
		return
	end
	
	for i =1,12 do
		if self.sell_item_list[i] then
			str = str..i..self.sell_item_list[i].name..self.sell_item_list[i].type_id..','
		end	
	end	
	print(str)	
end	
--添加商品
function mt:add_sell_item(name,i)
	local data = ac.table.ItemData[name]
	if not data then
		data = ac.skill[name]
		if not data.is_skill then
			-- print('商店添加物品失败,不存在数据',name)
			return
		end
	end

	local item = ac.item.create(name,i)
	item.shop_slot_id = i
	--刷新物品数据                        ''..self:get_name()
	-- print(item.name,self:get_name())
	item:set_sell_state('                   '..self:get_name())
	if not self.sell_item_list then 
		self.sell_item_list = {}
	end	
	if item then 
		self.sell_item_list[i] = item
		self.sell[i] = item.name
	end	
	--添加到商店
	jass.AddItemToStock(self.handle,base.string2id(item.type_id),1,1)
	item:hide()
	--删掉物品
	-- jass.RemoveItem(item.handle)
	-- print(item.handle)
	return item
end

--寻找物品 --一个物品只能被添加到一个单位身上
--可根据物品名称，或是物品品质返回物品。
function mt:find_sell_item(it)
	if type(it) == 'string' then 
		it_name = it
	else 
		if it.name then
			it_name = it.name
		else 
			print('传入的物品没有名称')
			return 
		end
	end	
	-- it_name = clean_color(it_name)
	local item = ac.item.shop_item_map[it_name]

	return item
end

--移除商品
--一个商店只支持一个物品模板，如果已经添加过，图标刷新不了
--删除这个商品时，会莫名的删掉另外一些商品
--测试得出，一个物品模板已经被添加到商店后，从商店删除（模板已回收），
--再添加时， 另一个商店的icon不会变
function mt:remove_sell_item(it)
	local item = self:find_sell_item(it)
	if not item  then 
		return
	end	
	local shop_slot_id = item.shop_slot_id
	-- --回收
	ac.item.shop_item_map[item.name] = nil
	ac.shop_item_list[item.type_id] = false --true回收模板
	self.sell_item_list[shop_slot_id] = nil
	self.sell[shop_slot_id] = nil
	
	-- print('从商店移除',item.type_id,item.name,item.shop_slot_id)
	--从商店移除
	jass.RemoveItemFromStock(self.handle,base.string2id(item.type_id))
	jass.RemoveItem(item.handle)

end
--移除全部商品
--无用
function mt:remove_all()
	for i =1,12 do
		if self.sell_item_list[i] then
			self:remove_sell_item(self.sell_item_list[i].name)
		end	
	end	
end
function mt:fresh_sell()
	for i =1,12 do
		if self.sell_item_list[i] then
			self.sell[i] = self.sell_item_list[i].name
		end	
	end	
end	
--刷新一次商店（删除商店再创建商店）
--sell 即将刷新的清单， sell_item_list 现在拥有的清单，执行添加会刷新sell清单。
--是否继承价格 默认都是不继承价格的
function mt:fresh()

	local sell = self.sell
	local data = {}
	data.sell = {}
	data.sell_item_list = {}
	data.sell_new_gold = {}
	for i=1,12 do 
		data.sell[i] = sell[i]
		data.sell_item_list[i] = self.sell_item_list[i]
		data.sell_new_gold[i] = self.sell_new_gold[i]
	end	

	--全部删除
	self:remove_all()

	--再添加一次
	--也要继承玩家价
	for i=1,12 do 
		if data.sell[i] then 
			local new_shop_item = self:add_sell_item(data.sell[i] ,i)
			--新物品继承属性
			if new_shop_item and not data.sell_new_gold[i]  then 
				if data.sell_item_list[i] and data.sell_item_list[i].gold then 
					local it = data.sell_item_list[i]
					new_shop_item.player_gold = it.player_gold
					local gold 
					if it.player_gold then 
						gold = it.player_gold[ac.player.self] 
					end	
					new_shop_item.gold = gold or it.gold
					--刷新数据
					new_shop_item:set_sell_state('                   '..self:get_name())
					--设置回原来的价格
					new_shop_item.gold = it.gold
				end	
			end	
		end	
	end	
end	

--native RemoveItemFromStock takes unit whichUnit, integer itemId returns nothing


--需要以下事件

-- ac.game:event '单位-拾取物品'(function(_,u,item)
	
-- end)

-- ac.game:event '单位-移动物品'(function(_,u,item,source_slotid,target_slotid)
	
-- end)

-- ac.game:event '单位-给与物品'(function(_,u,item,target)
	
-- end)

-- ac.game:event '单位-点击商店物品'(function(_,shop,u,item)
	
-- end)
         
-- ac.game:event '单位-切换背包'(function(_,u,page)
	
-- end)

-- ac.game:event '单位-丢弃物品'(function(_,u,item)
	
-- end)

return shop