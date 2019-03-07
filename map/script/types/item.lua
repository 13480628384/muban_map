
local slk = require 'jass.slk'
local game = require 'types.game'
local jass = require 'jass.common'
local dbg = require 'jass.debug'
local skill = require 'ac.skill'
local table = table
local japi = require 'jass.japi'
local runtime = require 'jass.runtime'
local affix = require 'types.affix'
local setmetatable = setmetatable
local xpcall = xpcall
local select = select
local error_handle = runtime.error_handle
local unit = require 'types.unit'

local item = {}
local mt = {}
ac.item = item

item.__index = mt
setmetatable(mt, skill)

item.item_map = {}
item.shop_item_map = {}

--类型
mt.type = 'item'

--物品分类
mt.item_type = '无'

--技能分类
-- mt.skill_type = '物品'

--物品等级
mt.level = 1

--所属单位
mt.owner = nil

--价格
mt.gold = 0

--物品所在的格子
mt.slot_id = nil

--物品是否唯一 如两把新手剑,会丢弃一个
mt.unique = false

--物品类型最大数量 如武器类型 最多带一个 0为不限制
mt.type_count = 0

--物品类型ID
mt.type_id = 0

--物品句柄
mt.handle = nil

--物品名
mt.name = ''

--是否可以丢弃
mt.drop = true

--物品数量 (数量为0的物品使用完不会删除，有使用次数的物品使用完会被删除)
mt._count = 0

--模型
-- 需要完善:依据装备品质，设置默认的模型
mt._model = [[Objects\InventoryItems\TreasureChest\treasurechest.mdl]]

--可以出售
mt.sell = true

--物品出售折扣
mt.discount = 0.5
--默认物品图标 书籍
mt.art = [[ReplaceableTextures\CommandButtons\BTNSnazzyScrollPurple.blp]]

--商品最大库存


--商品库存恢复时间


--颜色代码
local color_code = {
    ['红'] = 'ff0000',
    ['绿'] = '00ff00', 
    ['蓝'] = '00bdec',--浅蓝
    ['黄'] = 'ffff00',
    ['青'] = '00ffff',
    ['紫'] = 'df19d0',
    ['橙'] = 'ff8000',
    ['棕'] = 'a67d3d',
    ['粉'] = 'bc8f8f',
    ['白'] = 'ffffff',
    ['黑'] = '000000',
    ['金'] = 'ffff00',
    ['灰'] = 'cccccc',
}
ac.color_code = color_code

--颜色模型 目前应用于仙丹
local color_model = {
    ['白'] = [[faguangbai.mdx]],
    ['蓝'] = [[faguanglan.mdx]],
    ['金'] = [[faguanghuang.mdx]],
    ['红'] = [[faguanghong.mdx]],
    ['绿'] = [[faguanglv.mdx]],
    
}
local drop_flag = false
local item_slk = slk.item

--获取一个句柄
function ac.get_item_handle()
	local id = ac.item_list[#ac.item_list]
	if not id then
		print('物品句柄上限')
		return
	end

	table.remove(ac.item_list)
	return id
end

--回收句柄
function ac.remove_item_handle(handle)
	print('回收句柄',handle)
	table.insert(ac.item_list,handle)
end

--获取物品对应的技能id 物编内的
function mt:get_item_skillid()
	local id = self.type_id
	return 'A'..string.sub(id,2,4)
end

--获取物品名
function mt:get_name()
	return self.name
end


--设置物品名
function mt:set_name(name)
	self.name = name
	local id = self.type_id
	local color = color_code[self.color or '白']
	local str = '|cff'..color..tostring(name)..'|r'
	self.store_name = str
	japi.EXSetItemDataString(base.string2id(id),4,str)
end

--设置物品说明
--物品掉落地上时，点击物品的说明
function mt:set_descrition(str)
	local id = self.type_id
	japi.EXSetItemDataString(base.string2id(id),5,str)
end

--设置物品描述
function mt:set_tip(str)
	local id = self.type_id
	japi.EXSetItemDataString(base.string2id(id),3,str)
	japi.EXSetItemDataString(base.string2id(id),5,str)
end

--设置贴图
function mt:set_art(art)
	self.art = art or self.art
	local id = self.type_id
	japi.EXSetItemDataString(base.string2id(id),1,self.art)
end

--设置位置
function mt:setPoint(point)
	local x, y = point:get()
	jass.SetItemPosition(self.handle, x, y) --设置物品的位置
	self:show(true)

	return true
end

--设置是否可丢弃
function mt:disable_drop(is)
	jass.SetItemDroppable(self.handle, is)
end

--获取购买价格
function mt:buy_price()
	return self.gold or 0
end

--获取出售价格
function mt:sell_price()
	local count = self:get_item_count()
	local gold = self.gold
	if count > 1 then
		gold = gold * count
	end
	gold = math.floor(gold * self.discount)
	return gold
end

--增加物品层数
function mt:add_item_count(count)
	local i = self._count + count
	self:set_item_count(i)
	self._count = i
end

--设置物品使用层数
function mt:set_item_count(count)
	self._count = count
	if count > 0 then 
		jass.SetItemCharges(self.handle,count)
		
	else 
		self:item_remove()	
	end	
end

--获取物品使用层数
function mt:get_item_count()
	return self._count or 0
end

--显示物品 是否显示地上的模型
function mt:show(is)
	if not self.handle then 
		return
	end	
	local handle = self.handle
	jass.SetItemVisible(handle,true)
	if is then
		if self._eff then
			self._eff:remove()
		end
		-- print(self:get_point())
		self._eff = ac.effect(self:get_point(),self._model,270,1,'origin')
	end
end

--隐藏物品 隐藏时会把地上的模型也删掉
function mt:hide()
	local handle = self.handle
	jass.SetItemVisible(handle,false)
	if self._eff then
		self._eff:remove()
	end
end

--物品是否可见 在单位身上 or 被隐藏起来的物品 都会返回false
function mt:is_show()
	return ((jass.IsItemVisible(self.handle) == true))
end

--获取物品在地上的坐标
function mt:get_point()
	local x,y = jass.GetItemX(self.handle),jass.GetItemY(self.handle)
	return ac.point(x,y)
end

--初始化一下技能
function mt:item_init_skill()
	local hero = self.owner
	if not hero then
		print('初始化技能失败，没有所有者',self.name)
		return
	end

	local lv = self.level
	self.level = 0
	self:upgrade(lv)
	self:fresh()
	japi.EXSetAbilityDataReal(self:get_handle(), 1, 0x69, self.cool or 0)
	self.is_skill_init = true
end
function mt:get_item_lni_tip(str)
	local item_tip = str or (self.lni_data and self.lni_data.tip ) or ''
	-- print(item_tip)
	item_tip = item_tip:gsub('%%([%S_]*)%%', function(k)
		local value = self[k]
		local tp = type(value)
		if tp == 'function' then
			return value(data)
		end
		return '|cff'..color_code['金']..tostring(value)..'|r'
	end)

	return item_tip
end	
--获取物品描述
function mt:get_tip()
	local owner = self.owner
	local store_title =''
	local gold
	local skill_tip = self:get_simple_tip() or ''
	local item_tip = self:get_item_lni_tip() or ''
    local tip = ''

	--如果物品tip和技能tip一致，不添加技能tip
	--去掉颜色代码
	local t_str = skill_tip:gsub('|[cC]%w%w%w%w%w%w%w%w(.-)|[rR]','%1'):gsub('|n','\n'):gsub('\r','\n')
	local s_str = item_tip:gsub('|[cC]%w%w%w%w%w%w%w%w(.-)|[rR]','%1'):gsub('|n','\n'):gsub('\r','\n')

	if owner then
		--有所属单位则说明物品在身上
		 gold = '|cffebd43d(出售：'..self:sell_price()..')|r|n'
	else
		--否则就是在地上或商店里，地上不用管，商店的话修改出售价格
		 store_title = self.store_name..'|r\n'
		--否则就是在地上或商店里，地上不用管，商店的话修改出售价格
		 gold = '|cffebd43d(价格：'..self:buy_price()..')|r|n'
	end
	
	tip = store_title..gold..'\n\n'.. item_tip

	if skill_tip and t_str ~= s_str then 
	    if item_tip ~='' then  
			local temp_tip = '|cff'..color_code['灰']..'技能：'..'|r'..'\n' 
		end	
		tip = tip..(temp_tip or '')..skill_tip..'\n'
	end	
	tip = tip ..'\n' 
	return tip
	
end
local function register_item_destroy_event(item_handle)
	if not  item_handle  or item_handle == 0 then 
		return 
	end	
	local trg = jass.CreateTrigger()

	jass.TriggerRegisterDeathEvent(trg,item_handle)

	jass.TriggerAddAction(trg,function ()
		local handle = GetTriggerWidget()
		print(handle,jass.GetHandleId(handle))
		local it = ac.item.item_map[handle]
        -- print('触发丢弃物品',it.owner,it.name,it._model)
		if not it then
			return
		end
		if it._eff then 
			it._eff:remove()
		end	
	end)
	
end

--单位获得物品 添加属性
function mt:on_add_state()
	local hero = self.owner

	if not hero or not hero:is_type('英雄') then 
		return
	end	

	--保存物品
	local name = self.name

	--单位的属性表
	local data = ac.unit.attribute

	local state = {}
	for key in pairs(data) do 
		local value 
		if self.random then 
			value = self.randm_data[key]
			if value then 
				value = math.random(value[1],value[2])
			end 
		else 
			value = self[key]
		end 
		if value then 
			table.insert(state,{name = key,value = value})
		end 
		key = key..'%'
		value = self[key]
		if value then 
			table.insert(state,{name = key,value = value})
		end 
	end
	table.sort(state,function (a,b)
		return a.name < b.name
	end) 

	local is_show_text = self:get_type() == '神符'
	for index,value in ipairs(state) do 
		if is_show_text then 
			ac.texttag
			{
				string = value.name .. ' +' .. value.value,
				size = 10,
				position = hero:get_point(),
				speed = 86,
				red = (self.color[1] / 255 * 100),
				green = (self.color[2] / 255 * 100),
				blue = (self.color[3] / 255 * 100),
				player = hero:get_owner()
			}
		end
		-- print('物品添加属性：',value.name,value.value)
		if self.item_type ~= '消耗品' then
			hero:add_tran(value.name,value.value)
		end	
	end 

	self.state = state
end
--单位 使用物品 添加属性
function mt:on_use_state()
	local hero = self.owner
	
	if not hero then 
		return
	end	
	--让宠物使用物品时给英雄增加对应的属性
	hero = hero:get_owner().hero

	--保存物品
	local name = self.name

	--单位的属性表
	local data = ac.unit.attribute

	local state = {}
	for key in pairs(data) do 
		local value 
		if self.random then 
			value = self.randm_data[key]
			if value then 
				value = math.random(value[1],value[2])
			end 
		else 
			value = self[key]
		end 
		if value then 
			table.insert(state,{name = key,value = value})
		end 
		key = key..'%'
		value = self[key]
		if value then 
			table.insert(state,{name = key,value = value})
		end 
	end
	table.sort(state,function (a,b)
		return a.name < b.name
	end) 

	local is_show_text = self:get_type() == '神符'
	for index,value in ipairs(state) do 
		if is_show_text then 
			ac.texttag
			{
				string = value.name .. ' +' .. value.value,
				size = 10,
				position = hero:get_point(),
				speed = 86,
				red = (self.color[1] / 255 * 100),
				green = (self.color[2] / 255 * 100),
				blue = (self.color[3] / 255 * 100),
				player = hero:get_owner()
			}
		end
		if self.item_type == '消耗品' then
			print('使用物品,增加属性：',name,value.name,value.value)
			hero:add_tran(value.name,value.value)
		end	
	end 

end


--单位失去物品 扣除属性
function mt:on_remove_state()
	local hero = self.owner

	if not hero then 
		return
	end	

	local name = self.name

	if self.state then 
		for index,value in ipairs(self.state) do 

			if self.item_type ~= '消耗品' then
				hero:add_tran(value.name,-value.value)
			end	

		end 
		self.state = nil 
	end
end

--删除物品
function mt:item_remove(is)
	print('即将移除物品：',self.slot_id,self.name,self.handle)
	
	--移除技能
    -- if self._eff then 
    --     print('即将移除物品：:',self.handle,self.name,self._eff.unit:get_point())
	-- end
	-- if self.owner then 
	-- 	self:_call_event 'on_remove'
	-- end	
	jass.RemoveItem(self.handle)
	dbg.handle_unref(self.handle)
	
	--移除物品时，如果物品在单位身上，会触发单位丢弃物品事件，会先执行下面代码，再执行单位丢弃。
	self.is_discard_event = true
	if self.owner then 
		self.owner:remove_item(self)
	end	

	-- if self  then 
	-- 	if self.slot_id then 
	-- 		self.owner.item_list[self.slot_id] =nil
	-- 	end	
	-- 	self:on_remove_state()
	-- end	

	ac.item.item_map[self.handle] = nil
	self.handle = nil
	self.owner = nil
	self.slot_id = nil
	ac.remove_item_handle(self.type_id)
	if self._eff then
		self._eff:remove()
	end
	
end

--单位是否有物品,查到立即返回
--可根据物品名称，或是物品品质返回物品。
function unit.__index:has_item(it)
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
	local item 
	for i=1,6 do
		local items = self:get_slot_item(i)
		if items and (items.name == it_name or items.color == it_name)then
			item = items
			break
		end
	end
	return item
end

--单位是否有物品,handle 查询,查到立即返回
function unit.__index:has_item_handle(handle)
	if not handle then 
		return 
	end	

	local item 
	for i=1,6 do
		local items = self:get_slot_item(i)
		if items and items.handle == handle  then
			item = items
			break
		end
	end

	return item
end

--添加物品
--true,满格掉地上。默认是阻止添加。
--应用： 合成装备时，满格掉落地上,给与装备，满格掉落
function unit.__index:add_item(it,is_fall)

	--如果没有初始化则创建
	-- print('添加物品',items)
	if type(it) =='string'  then 	
		--不创建特效
		it = ac.item.create_item(it,nil,true)
		it:hide()
		it.recycle = true
	end	
	if not self.item_list  then 
		self.item_list ={}
	end	
	if self:has_item_handle(it.handle) then 
		-- print('单位已有该物品不需要添加')
		--不阻止 丢弃物品事件
		it.is_discard_event = false 
		return 
	end
	
	
	--为了合成装备
	-- print('装备2',it)
	if self:event_dispatch('单位-合成装备', self, it) then
		self.buy_suc = true 
		return 
	end
	
	if self:event_dispatch('单位-即将获得物品', self, it) then
		--唯一时，掉落地上
		if is_fall then
			it:setPoint(self:get_point())
		end 
		if it.recycle then
			-- print(it.name,it.handle)
			it:item_remove()
		end		
		 
		--给与 时的处理逻辑
		-- 唯一装备可能要处理下。
		if it.geiyu then
			it.geiyu = false 
			-- print(it.name)
			-- if it.item_type == '消耗品' then 
			-- 	it:item_remove()
			-- end	
		end 
		return
	end
	
	--获取一个空槽位
	local slot = self:get_nil_slot()
	if not slot then
		self.owner:showSysWarning('物品栏已满')
		--满格时，掉落地上
		if is_fall then
			it:setPoint(self:get_point())
		end 
		return
	end

	self.buy_suc = true 
	it.owner = self
	self.item_list[slot] = it
	it.slot_id = slot
	-- print('获得物品',it.handle,it.owner,it.name,it.slot_id)
	self:print_item(true)
	-- 如果单位身上已经有这个物品的handle了，再添加一次会触发先丢弃再获得物品事件。
	jass.UnitAddItem(self.handle,it.handle)

	--不阻止 丢弃物品事件   
	--有时很奇怪，已经获得这个物品了，再用UnitAddItem 添加时，没有丢弃物品。所以这边操作是个修补操作
	it.is_discard_event = false 

	
	if not it.is_skill_init then
		it:item_init_skill()
	else
		it:_call_event 'on_add'
	end
			
	it:on_add_state() 

	ac.wait(10,function()
		it:hide()
	end)

	self:event_notify('单位-获得物品后',self, it)

	-- self:print_item(true)
	--刷新tip
	-- it:fresh_tip()
	return it
end
--打印单位身上的物品 ，打印全部 或是 当前页
function unit.__index:print_item(all)
	-- 测试 是否移除成功
	local pt = ''
	if not all  then 
		for i = 1,6 do
			local item = self:get_slot_item(i)
			if item then 
				pt = pt ..item.slot_id ..item.name .. ','
			end	
		end
	else
		for i = 1,100 do
			local item = self.item_list[i]
			if item then 
				pt = pt ..item.slot_id ..item.name .. ','
			end	
		end
	end	
	print(pt)
end
--单位移除找到的物品
--	具体的某物品或根据名字找到的第一个物品
--	false 真删 ,true 丢在地上。
-- modify by jeff 从单位身上移除装备，都是丢在地上
function unit.__index:remove_item(it)
	if not it  then
		return false
	end
	
	-- print('即将从单位移除物品：',it.slot_id,it.name,it.handle,ac.clock())
	it:on_remove_state()
	--移除技能
	it:_call_event 'on_remove'

	--神符类的物品，有所有者，但是没有slot_id 所以，需要做一重判断
	local slot = it.slot_id

	--删除单位身上的table值
	if slot then 
		self.item_list[slot] = nil
	end	
	it.slot_id = nil
	it.owner = nil
	-- if not is_drop then 
	-- 	it:item_remove()
	-- end	
	
	return true
end


--获取一个空槽位
function unit.__index:get_nil_slot()
	local a,b = self:get_bar_page()
	for i=a,b do
		local slot = self.item_list[i]
		if not slot then
			return i
		end
	end
	return
end

--获取指定槽位的物品
function unit.__index:get_slot_item(slot)
	local page = self.currentpage or 1
	slot = (page - 1) * 6 + slot

	local item = self.item_list[slot]
	if item then
		return item
	end
	return
end

--获取当前页面索引，如第一页是1-6
function unit.__index:get_bar_page()
	local page = self.currentpage or 1
	local a = (page - 1) * 6 + 1
	local b = a + 5
	return a,b
end

--是否存在同名武器
function unit.__index:get_unique_name(it)
	for i=1,6 do
		local items = self:get_slot_item(i)
		if items and items.name == it.name then
			return items
		end
	end
	return 
end


--判断以携带同类型物品数量是否超标
function unit.__index:get_type_count(it)
	if it.type_count == 0 then
		return false
	end

	local count = it.type_count
	local n = 0
	for i=1,6 do
		local items = self:get_slot_item(i)
		if items and items.item_type == it.item_type then
			n=n+1
			if n >= count then
				return true
			end
		end
	end

	return false
end


--创建物品
--物品名称
--位置
--是否创建特效，默认创建,true 不创建， false 创建
function ac.item.create_item(name,poi,is)
	--创建一个物品
	local items = setmetatable({},item)
	
	--在继承skill的属性(如果带技能的话,不存在技能时遍历一下也无所谓)
	local data = ac.skill[name]
	for k, v in pairs(data) do
		items[k] = v
	end	

	--如果存在lni则继承lni的属性
	local data = ac.table.ItemData[name]
	items.lni_data = data
	if data then
		for k, v in pairs(data) do
			items[k] = v
		end
	end
	

	--读取一个句柄
	local type_id = ac.get_item_handle()
	items.type_id = type_id
	--如果有坐标，则说明创建在地上的
	local x,y = 0,0
	-- print('指定坐标创建物品',poi)
	if poi then
		x,y = poi:get()
	end
	
	--创建一个实例物品
	local item_handle = jass.CreateItem(base.string2id(type_id),x,y)
	dbg.handle_ref(item_handle)
	items.handle = item_handle

	x = jass.GetItemX(item_handle)
	y = jass.GetItemY(item_handle)

	--设置物品模型 消耗品
	if items.color and items.item_type == '消耗品' then 
		items._model = color_model[items.color]
	end

	if not is then 
		items._eff = ac.effect(ac.point(x,y),items._model,270,1,'origin')
    end

	--设置使用次数
	if items.item_type == '消耗品' and items._count == 0 then 
		items._count = 1
	end	
	if items._count > 0 then 
		items:set_item_count(items._count)
	end
	-- print(items.name,items.item_type,items._count)
	--设置物品名
	items:set_name(name)

	-- print(items.tip)
	--设置tip
	items:set_tip(items:get_tip())

	--设置贴图
	items:set_art(items.art)

	--是否可以丢弃
	items:disable_drop(items.drop)

	local skill_id = items:get_item_skillid()
	items.ability_id = skill_id

	--绑定 物品被A时，地上特效删除 的事件
	-- 会引起掉线 不用
	-- register_item_destroy_event(item_handle)

	-- 记录全图物品
	ac.item.item_map[items.handle] = items
	
	return items
end


--创建物品 - 商店使用
--@商品位置 必填
function item.create(name,pos)
	
	--创建一个物品
	local items = setmetatable({},item)


	--在继承skill的属性(如果带技能的话,不存在技能时遍历一下也无所谓)
	local data = ac.skill[name]
	for k, v in pairs(data) do
		items[k] = v
	end	

	--如果存在lni则继承lni的属性
	local data = ac.table.ItemData[name]
	if data then
		for k, v in pairs(data) do
			items[k] = v
		end
	end

	local type_id = ac.get_shop_item_handle(pos)
	items.type_id = type_id

	--创建一个实例物品
	local item_handle = jass.CreateItem(base.string2id(type_id),0,0)
	ac.item.shop_item_map[name] = items

	items.handle = item_handle
	--设置物品名
	items:set_name(name)
	--设置贴图
	items:set_art(items.art)
	--设置tip
	items:set_tip(items:get_tip())
	if ac.skill[name].is_skill then
		items.is_skill = true
	end
	return items
end

--商店标题
function mt:set_store_title(title)
	japi.EXSetItemDataString(base.string2id(self.type_id), 2,title)
end

--更新商店信息
function mt:set_sell_state(str)
	--设置物品名
	self:set_name(self.name)
	--设置贴图
	self:set_art(self.art)
	--设置tip
	self:set_tip(self:get_tip())
	--设置商店出售名 颜色没法呈现
	self:set_store_title(str or ' ')
end



--检查施法条件
function mt:conditions(skills,target)
	--是否在施法范围内
	if not skills:is_in_range(target) then
		return
	end
	local on_target = target
	--无目标
	if not target then
		if skills.target_type ~= skills.TARGET_TYPE_NONE then
			return false
		else
			on_target = skills.owner
		end
	elseif target.type == 'unit' then
		if skills.target_type ~= skills.TARGET_TYPE_UNIT and skills.target_type ~= skills.TARGET_TYPE_UNIT_OR_POINT then
			return false
		end
	elseif target.type == 'point' then
		
		if skills.target_type ~= skills.TARGET_TYPE_POINT and skills.target_type ~= skills.TARGET_TYPE_UNIT_OR_POINT then
			return false
		end
	else
		return false
	end

	skills.target = on_target
	return true
end


	
return item

