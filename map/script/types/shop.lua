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

--拥有的商品

--创建一个商店
function shop.create(name,x,y,face)
	local unit = ac.player[11]:create_unit(name,ac.point(x,y),face)
	unit:add_restriction '物免'
	unit:add_restriction '魔免'
	unit:add_restriction '无敌'
	--继承商店
	setmetatable(unit, shop)
	local data = ac.table.UnitData[name]
	local sell = data.sell
	for i,v in ipairs(sell) do
		unit:add_sell_item(v)
	end

	shop.unit_list[unit.handle] = unit

	local j_trg = war3.CreateTrigger(function()
		--贩卖者
		local tra = shop.unit_list[jass.GetSellingUnit()]
		--购买者
		local u = ac.unit.j_unit(jass.GetBuyingUnit())
		--被购买的物品名，没办法保存物品handle，因为物品添加给商店时就被删除了
		-- 添加颜色代码会导致物品没有在商店里面创建。
		local it_name = jass.GetItemName(jass.GetSoldItem())
		it_name = clean_color(it_name)
		local it = ac.item.shop_item_map[it_name]

		--删掉物品排泄(神符类物品需要删除)
		jass.RemoveItem(jass.GetSoldItem())

		if not u or not tra or not it then
			return
		end

		u:event_notify('单位-点击商店物品',tra,u,it)
	end)

	for i = 1, 13 do
		jass.TriggerRegisterPlayerUnitEvent(j_trg, ac.player[i].handle, jass.EVENT_PLAYER_UNIT_SELL_ITEM, nil)
	end

	return unit
end

--添加商品
function mt:add_sell_item(name)
	local data = ac.table.ItemData[name]
	if not data then
		data = ac.skill[name]
		if not data then
			print('商店添加物品失败,不存在数据',name)
			return
		end
	end

	local item = ac.item.create(name)
	--刷新物品数据
	item:set_sell_state()

	--添加到商店
	jass.AddItemToStock(self.handle,base.string2id(item.type_id),1,1)

	--删掉物品
	jass.RemoveItem(item.handle)
end



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