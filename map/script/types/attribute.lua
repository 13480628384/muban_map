local jass = require 'jass.common'
local japi = require 'jass.japi'
local move = require 'types.move'
local unit = require 'types.unit'



oldSetUnitState = japi.SetUnitState--(self.handle, 0x11, 1)
oldGetUnitState = japi.GetUnitState--(self.handle, 0x12) + 1

japi.SetUnitState = function (handle,id,num)
	if type(id) == 'number' then 
		id = jass.ConvertUnitState(id)
	end
	return oldSetUnitState(handle,id,num)
end 

japi.GetUnitState = function (handle,id)
	if type(id) == 'number' then 
		id = jass.ConvertUnitState(id)
	end
	return oldGetUnitState(handle,id)
end 


local math = math
local string_gsub = string.gsub

local mt = ac.unit.__index

local attribute = {
	['力量']	=	true,--默认基础值  
	['敏捷']	=	true,--默认基础值
	['智力']	=	true,--默认基础值
	['生命']       = true,--默认基础值
	['生命上限']    = true,--默认基础值
	['生命恢复']    = true,--默认基础值
	['生命脱战恢复'] = true,--默认基础值
	['魔法']       = true,--默认基础值
	['魔法上限']    = true,--默认基础值
	['魔法恢复']    = true,--默认基础值
	['魔法脱战恢复'] = true,--默认基础值
	['能量获取率']   = true, --默认%
	['攻击']       = true, --默认基础值
	['护甲']       = true, --默认基础值
	['魔抗']	   = true, --默认基础值
	['攻击间隔']    = true, --默认基础值
	['攻击速度']    = true, --默认默认% 
	['攻击距离']    = true, --默认基础值
	['移动速度']    = true, --默认基础值 
	['减耗']       = true,  --默认基础值 减少扣篮量
	['冷却缩减']    = true, --默认% 
	['吸血']       = true,  --默认%
	['溅射']       = true,  --默认%
	['格挡']       = true,  --默认%
	['格挡伤害']    = true,  --默认%
	['暴击']       = true,   --默认%
	['暴击伤害']    = true,  --默认%
	['闪避'] = true,  --默认表示为%
	['破甲']       = true,  --默认表示为基础值  破加伤害计算时，默认0,增加属性时，若用add[破甲%]，将无效。伤害计算时，直接扣掉点数
	['破魔']       = true,  --默认表示为基础值  破加伤害计算时，默认0,增加属性时，若用add[破甲%]，将无效。伤害计算时，直接扣掉点数
	['穿透']       = true,  --默认表示为% 穿透，伤害计算时，穿透/100 再扣除
	['穿魔']       = true,  --默认表示为% 穿透，伤害计算时，穿透/100 再扣除
	['护盾']       = true,  --默认表示为基础值 
	['物爆几率']		=	true, --默认%
	['物爆伤害']		=	true,--默认%
	['会心几率']		=	true,--默认%
	['会心伤害']		=	true,--默认%
	['法爆几率']		=	true,--默认%
	['法爆伤害']		=	true,--默认%
	['技能伤害']		=	true, --默认表示为%
	['技能基础伤害']	 =	true, --默认表示为基础值
	['减免']			=	true, --默认表示为%
	['减伤']		    =	true, --默认表示为基础值
	['法术伤害减免']			=	true, --默认表示为%
	['法术伤害减伤']		    =	true, --默认表示为基础值
	['金币加成']		=	true,--默认表示为%
	['经验加成']		=	true,--默认表示为%
	['天赋触发几率']	=	true,--默认表示为%
	['多重射']	=	true,--默认表示为基础值
	['额外投射物数量']	=	true,--默认表示为基础值
	['额外连锁数量']	=	true,--默认表示为基础值
	['额外范围']		=	true,--默认表示为基础值
	['攻击回血']		=	true,--默认表示为基础值
	['击杀回血']		=	true,--默认表示为基础值
	['对BOSS额外伤害']  =   true,--默认表示为%
	['基础金币']  =   true,--默认表示为基础值
	['积分加成']  =   true,--默认表示为基础值
	['熟练度加成']  =   true,--默认表示为基础值

	
	['额外伤害'] = true, --默认表示为基础值
	['物品获取率'] = true,--默认表示为% 怪物物品掉落率加成
	['法术攻击'] = true, --默认表示为% 技能的法术伤害加成
	['召唤物'] = true, --默认表示为基础值,召唤物数量
	['召唤物属性'] = true, --默认表示为%, 召唤物属性加成
	['主动释放的增益效果'] = true,  --默认表示为%

	['减甲'] = true,  --默认表示为基础值 永久性减甲
	

	['杀怪力量'] = true,  --默认表示为基础值
	['杀怪敏捷'] = true,  --默认表示为基础值
	['杀怪智力'] = true,  --默认表示为基础值
	['杀怪全属性'] = true,  --默认表示为基础值
	['杀怪护甲'] = true,  --默认表示为基础值

	['每秒金币'] = true,  --默认表示为基础值
	['每秒力量'] = true,  --默认表示为基础值
	['每秒敏捷'] = true,  --默认表示为基础值
	['每秒智力'] = true,  --默认表示为基础值
	['每秒全属性'] = true,  --默认表示为基础值
	['每秒护甲'] = true,  --默认表示为基础值
	
}
ac.unit.attribute = attribute
local set = {}
local get = {}
local on_add = {}
local on_get = {}
local on_set = {}

--基础值
local base_attr =[[
力量 敏捷 智力 生命 生命上限 生命恢复 生命脱战恢复 魔法 
魔法上限 魔法脱战恢复 攻击 护甲 魔抗 攻击间隔 攻击距离 移动速度 减耗 破甲 
破魔 护盾 减伤 技能基础伤害 多重射 额外连锁 额外范围 攻击回血 击杀回血 基础金币 积分加成 熟练度加成
额外伤害 召唤物 
杀怪力量 杀怪敏捷 杀怪智力 杀怪全属性 杀怪护甲
每秒金币 每秒力量 每秒敏捷 每秒智力 每秒全属性 每秒护甲
减甲
]]


--如果加成的属性名有%,则部分转化为 直加
--add_tran(力量%,10) ,实际为 add(力量%,10)
--add_tran(攻击速度%,10) ,实际为 add(攻击速度,10)
function mt:add_tran(name, value)
	
	local base_name = name
	
	if name:sub(-1, -1) == '%' then
		base_name =  name:sub(1, -2)
		-- print(base_name)
		--如果是基础值，则调用英萌自带的加%函数，会先*基础值再+
		if finds(base_attr,base_name) then 
			self:add(name, value)
		else
		--%值 调用英萌自带的加，直接+
			self:add(base_name, value)
		end	
	else	
		--调用英萌自带的加，直接+
		self:add(base_name, value)
	end	

end	
--默认or false add('攻速%'，10) 先*再+，若攻速为200，最终值为220
function mt:add(name, value)
	local v1, v2 = 0, 0
	if name:sub(-1, -1) == '%' then
		v2 = value
		name = name:sub(1, -2)
	else
		v1 = value
	end
	if not attribute[name] then
		error('错误的属性名:' .. tostring(name))
		return
	end
	local key1 = name
	local key2 = name .. '%'
	local attr = self['属性']
	if not attr then
		attr = {}
		self['属性'] = attr
	end
	if not attr[key1] then
		attr[key1] = get[name] and get[name](self) or 0
		attr[key2] = 0
	end
	local f
	
	if on_set[name]  then
		f = on_set[name](self) 
	end
	if on_add[name] then
		v1, v2 =  on_add[name](self, v1, v2)
	end
	if v1 then
		attr[key1] = attr[key1] + v1
	end
	if v2 then
		attr[key2] = attr[key2] + v2
	end
	if set[name] then
		set[name](self, attr[key1] * (1 + attr[key2] / 100))
	end
	if f then
		f()
	end
	-- 增加10%时: 攻击200，攻击加10% ， 200*(1+0.1) = 220 , attr[key1]=200,  attr[key2] = 10%
	-- 减少10%时: 攻击220，攻击 -10% , attr[key1]=200,  attr[key2] = 10% -10% , 攻击200  
	-- 先增加10,再加10%时, 攻击200 ，attr[key1]=200 +10 , attr[key1] =10%， 最终增加 210*1.1 231
	-- 若 先减少10，再减少10%时， attr[key1]=200,  attr[key2] = 10% -10%   最终 200
	-- 若 先减少10%，再减少10时，  attr[key2] = 10% -10%，attr[key1]=200  最终 200
	-- 先增加10%，再增加10时，attr[key1]=200 +10 , attr[key2] =10%， 最终 220
end

function mt:set(name, value)
	if not attribute[name] then
		error('错误的属性名:' .. tostring(name))
		return
	end
	local key1 = name
	local key2 = name .. '%'
	local attr = self['属性']
	if not attr then
		attr = {}
		self['属性'] = attr
	end
	if not attr[key1] then
		attr[key1] = get[name] and get[name](self) or 0
		attr[key2] = 0
	end
	local f
	if on_set[name]  then
		-- local old_value = attr[key1]
		-- if name =='力量' then
		-- 	print('力量老值：',old_value)
		-- end	
		f = on_set[name](self) 
	end
	attr[key1] = value
	attr[key2] = 0
	if set[name] then
		set[name](self, attr[key1] * (1 + attr[key2] / 100))
	end
	if f then
		f()
	end
end

function mt:get(name)
	local type = 0
	if name:sub(-1, -1) == '%' then
		name = name:sub(1, -2)
		type = 1
	end
	if not attribute[name] then
		error('错误的属性名:' .. tostring(name))
		return
	end
	local key1 = name
	local key2 = name .. '%'
	local attr = self['属性']
	if not attr then
		attr = {}
		self['属性'] = attr
	end
	if not attr[key1] then
		attr[key1] = get[name] and get[name](self) or 0
		attr[key2] = 0
	end
	if type == 1 then
		return attr[key2]
	end
	if on_get[name] then
		return on_get[name](self, attr[key1] * (1 + attr[key2] / 100))
	end
	return attr[key1] * (1 + attr[key2] / 100)
end

-- 资源相关
-- 能量类型
mt.resource_type = '魔法'

function mt:add_resource(type, value)
	local type, match = string_gsub(type, self.resource_type, '魔法')
	if match == 0 then
		return
	end
	self:add(type, value)
end

function mt:get_resource(type)
	local type, match = string_gsub(type, self.resource_type, '魔法')
	if match == 0 then
		return 0
	end
	return self:get(type)
end

function mt:set_resource(type, value)
	local type, match = string_gsub(type, self.resource_type, '魔法')
	if match == 0 then
		return
	end
	self:set(type, value)
end

-- 每点力量增加8点生命上限，0.08点生命恢复，0.1%物爆伤害，如果是主属性，每点力量还增加4点攻击力
-- 每点敏捷增加0点护甲，0.05%攻击速度，0.1%会心伤害，如果是主属性，每点敏捷还增加4点攻击力
-- 每点智力增加8点魔法上限，0.08点魔法恢复，0.1%法爆伤害，如果是主属性，每点智力还增加4点攻击力

--主属性 每点主属性增加4点攻击力
local main_attribute_value = 3
--力量 
local str_hp = 6
local str_hp_recover = 0.06
local str_phy_split_damage = 0.01

--敏捷
local agi_speed = 0.01
local agi_heart = 0.01
local agi_defense = 0

--智力
local int_mp = 8
local int_mp_recover = 0.08
local int_explosion = 0.01
local int_skill_base_damage = 3


get['力量'] = function(self)
	if self.getStr then 
		return self:getStr()
	else
		-- print('不是英雄单位，没有力量')
		return 0	
	end	
end

set['力量'] = function(self, val)
	if self.setStr then 
		if val >= 1 then
			self:setStr(val)
		else
			self:setStr(1)
		end
	end	
end


on_set['力量'] = function(self)
    -- print("新值：",self:get '力量', "老值：",old_value)
	local old_value =  self:get '力量' --老值
	
	return function()
		local value = self:get '力量' - old_value
		if self.main_attribute and self.main_attribute == '力量' then
			-- 增加攻击
			self:add('攻击', value * main_attribute_value)
		end	

		self:add('生命上限',  value * str_hp)
		-- 增加生命恢复
		self:add('生命恢复',  value * str_hp_recover)
		-- 增加物爆伤害
		self:add('物爆伤害',  value * str_phy_split_damage)
	end	
-- end
end



get['敏捷'] = function(self)	
	if self.getAgi then 
		return self:getAgi()
	else
		-- print('不是英雄单位，没有敏捷')
		return 0	
	end	
end

set['敏捷'] = function(self, val)
	if self.setAgi then 
		if val >= 1 then
			self:setAgi(val)
		else
			self:setAgi(1)
		end
	end	
end

on_set['敏捷'] = function(self,old_value)
	local old_value =  self:get '敏捷' --老值
	return function()
		local value =  self:get '敏捷' - old_value
		if self.main_attribute and self.main_attribute == '敏捷' then
			-- 增加攻击
			self:add('攻击', value * main_attribute_value)
		end	
		-- 增加护甲
		self:add('护甲', value * agi_defense)
		-- 增加会心伤害
		self:add('会心伤害',  value * agi_heart)
		-- 增加攻击
		self:add('攻击速度', value * agi_speed)
	end	
end


get['智力'] = function(self)
	if self.getInt then 
		return self:getInt()
	else
		-- print('不是英雄单位，没有智力')
		return 0	
	end	
	
end

set['智力'] = function(self, val)
	if self.setInt then 
		if val >= 1 then
			self:setInt(val)
		else
			self:setInt(1)
		end
	end	
end

on_set['智力'] = function(self,old_value)

	local old_value =  self:get '智力' --老值
	return function()
		local value =  self:get '智力' - old_value
		if self.main_attribute and self.main_attribute == '智力' then
			-- 增加攻击
			-- print('主属性为',self.main_attribute,self:get '智力',old_value,main_attribute_value)
			self:add('攻击', value * main_attribute_value)
		end	
		-- 增加魔法上限
		self:add('魔法上限', value * int_mp)
		-- 增加魔法恢复
		self:add('魔法恢复', value * int_mp_recover)
		-- 增加法爆伤害
		self:add('法爆伤害', value * int_explosion)
		-- 增加技能基础伤害
		self:add('技能基础伤害', value * int_skill_base_damage)
	end
end


get['生命'] = function(self)
	return jass.GetWidgetLife(self.handle)
end

set['生命'] = function(self, life)
	-- print('设置生命2',life)
	if life > 1 then
		jass.SetWidgetLife(self.handle, life)

	else
		jass.SetWidgetLife(self.handle, 1)

	end

	self:event_notify('单位-生命变化',self)
end

on_get['生命'] = function(self, life)
	if life < 0 then
		return 0
	else
		local max_life = self:get '生命上限'
		if life > max_life then
			return max_life
		end
	end
	return life
end

get['生命上限'] = function(self)
	return jass.GetUnitState(self.handle, jass.UNIT_STATE_MAX_LIFE)
end

set['生命上限'] = function(self, max_life, old_max_life)
	if max_life < 0 then 
		max_life = 0
	end	
	japi.SetUnitState(self.handle, jass.UNIT_STATE_MAX_LIFE, max_life)
	if self.freshDefenceInfo then
		self:freshDefenceInfo()
	end
end

on_set['生命上限'] = function(self)
	if self:get '生命上限' <= 0 then 
		self:kill()
		return  
	end	
	local rate = self:get '生命' / self:get '生命上限'
	return function()
		-- print('设置生命1',self:get '生命上限' * rate)
		self:set('生命', self:get '生命上限' * rate)
	end
end

get['魔法'] = function(self)
	return jass.GetUnitState(self.handle, jass.UNIT_STATE_MANA)
end

set['魔法'] = function(self, mana)
	jass.SetUnitState(self.handle, jass.UNIT_STATE_MANA, math.ceil(mana))
	self:event_notify('单位-魔法变化',self)
end

on_add['魔法'] = function(self, v1, v2)
	v1 = v1 + v1 * self:get '能量获取率' / 100
	return v1, v2
end

on_get['魔法'] = function(self, mana)
	if mana < 0 then
		return 0
	else
		local max_mana = self:get '魔法上限'
		if mana > max_mana then
			return max_mana
		end
	end
	return mana
end

get['魔法上限'] = function(self)
	return jass.GetUnitState(self.handle, jass.UNIT_STATE_MAX_MANA)
end

set['魔法上限'] = function(self, max_mana)
	japi.SetUnitState(self.handle, jass.UNIT_STATE_MAX_MANA, max_mana)
end

on_set['魔法上限'] = function(self)

	local rate =0
	if self:get '魔法上限' > 0 then 
		 rate = self:get '魔法' / self:get '魔法上限'
	end
	
	return function()
		self:set('魔法', self:get '魔法上限' * rate)
	end
end

get['攻击'] = function(self)
	japi.SetUnitState(self.handle, jass.ConvertUnitState(0x10), 1)
	japi.SetUnitState(self.handle, jass.ConvertUnitState(0x11), 1)
	return japi.GetUnitState(self.handle, jass.ConvertUnitState(0x12)) + 1
end

set['攻击'] = function(self, attack)
	if attack <= 1 then 
		attack = 2
	end	
	--攻击上限 21亿
	if attack >= 2100000000 then 
		attack = 2100000000
	end	
	japi.SetUnitState(self.handle, jass.ConvertUnitState(0x12), attack - 1)
	if self.freshDamageInfo then
		self:freshDamageInfo()
	end
end

get['护甲'] = function(self)
	return japi.GetUnitState(self.handle, jass.ConvertUnitState(0x20))
end

set['护甲'] = function(self, defence)
	japi.SetUnitState(self.handle, jass.ConvertUnitState(0x20), defence)
	if self.freshDefenceInfo then
		self:freshDefenceInfo()
	end
end

get['攻击间隔'] = function(self)
	return japi.GetUnitState(self.handle, jass.ConvertUnitState(0x25))
end

on_get['攻击间隔'] = function(self, attack_gap)
	if attack_gap < 0.8 then
		attack_gap = 0.8
	end
	return attack_gap
end

set['攻击间隔'] = function(self, attack_gap)
	if attack_gap < 0.8 then
		attack_gap = 0.8
	end
	japi.SetUnitState(self.handle, jass.ConvertUnitState(0x25), attack_gap)
end

set['攻击速度'] = function(self, attack_speed)
	if attack_speed >= 0 then
		japi.SetUnitState(self.handle, jass.ConvertUnitState(0x51), 1 + attack_speed / 100)
	else
		--当攻击速度小于0的时候,每点相当于攻击间隔增加1%
		japi.SetUnitState(self.handle, jass.ConvertUnitState(0x51), 1 + attack_speed / (100 - attack_speed))
	end
end

on_set['攻击速度'] = function(self)
	return self:fresh_cool()
end

get['攻击距离'] = function(self)
	return japi.GetUnitState(self.handle, jass.ConvertUnitState(0x16))
end

set['攻击距离'] = function(self, attack_range)
	japi.SetUnitState(self.handle, jass.ConvertUnitState(0x16), attack_range)
	--修改攻击距离后同时修改主动攻击范围
	if self.owner:is_player() and self:get('攻击距离')>1000 then
		self:set_search_range(self:get '攻击距离')
	end
end

get['移动速度'] = function(self)
	return jass.GetUnitDefaultMoveSpeed(self.handle)
end

set['移动速度'] = function(self, move_speed)
	if not self:has_restriction '定身' then
		jass.SetUnitMoveSpeed(self.handle, move_speed)
	end
	move.update_speed(self, on_get['移动速度'](self, move_speed))
	--英雄属性面板
	if self.freshMoveSpeedInfo then
		self:freshMoveSpeedInfo()
	end
end

on_get['移动速度'] = function(self, move_speed)
	if move_speed < 0 then
		return 0
	elseif move_speed > 1000 then
		return 1000
	end
	return move_speed
end

on_set['减耗'] = function(self)
	return self:fresh_cost()
end

on_get['冷却缩减'] = function(self, cool_reduce)
	if cool_reduce > 80 then
		return 80
	end
	return cool_reduce
end

on_set['冷却缩减'] = function(self)
	return self:fresh_cool()
end

on_get['吸血'] = function(self, value)
	if value > 150 then
		return 150
	end
	return value
end

on_get['溅射'] = function(self, splash)
	if splash > 100 then
		return 100
	end
	return splash
end

set['格挡'] = function(self)
	if self.freshDefenceInfo then
		self:freshDefenceInfo()
	end
end

get['格挡伤害'] = function(self)
	return 60
end

set['格挡伤害'] = function(self)
	if self.freshDefenceInfo then
		self:freshDefenceInfo()
	end
end

set['暴击'] = function(self)
	if self.freshDamageInfo then
		self:freshDamageInfo()
	end
end

get['暴击伤害'] = function()
	return 150
end

set['暴击伤害'] = function(self)
	if self.freshDamageInfo then
		self:freshDamageInfo()
	end
end

on_get['物爆几率'] = function(self, physical_rate)
	if physical_rate > 90 then
		return 90
	end
	return physical_rate
end

on_get['法爆几率'] = function(self, magic_rate)
	if magic_rate > 90 then
		return 90
	end
	return magic_rate
end


on_get['会心几率'] = function(self, heart_rate)
	if heart_rate > 90 then
		return 90
	end
	return heart_rate
end


on_get['减免'] = function(self, reduce_damage)
	if reduce_damage > 90 then
		return 90
	end
	return reduce_damage
end

on_get['法术伤害减免'] = function(self, reduce_magic_damage)
	if reduce_magic_damage > 90 then
		return 90
	end
	return reduce_magic_damage
end

on_get['闪避'] = function(self, value)
	if value > 90 then
		return 90
	end
	return value
end
--破甲和破魔一样
on_get['破魔'] = function(self, value)
	return on_get['破甲']
end



--杀怪加全属性通用规则
ac.game:event '单位-杀死单位' (function(trg, killer, target)
	--召唤物杀死也继承
	local hero = killer:get_owner().hero
	if not hero then return end
	local str = hero:get('杀怪力量') + hero:get('杀怪全属性')
	local int = hero:get('杀怪智力') + hero:get('杀怪全属性')
	local agi = hero:get('杀怪敏捷') + hero:get('杀怪全属性')
	local defence = hero:get('杀怪护甲')
	--杀怪加全属性 
	hero:add('力量',str)
	hero:add('智力',int)
	hero:add('敏捷',agi)
	-- print('杀怪增加护甲：',defence)
	hero:add('护甲',defence)
	
end) 

--每秒金币
ac.loop(1*1000,function(t)
	for i = 1,10 do 
		local player= ac.player(i)
		if player:is_player() and player.hero then 
			--每秒金币
			local gold = player.hero:get('每秒金币') 
			player:addGold(gold) --不显示漂浮文字
			local hero = player.hero
			
			--每秒属性 
			local str = hero:get('每秒力量') + hero:get('每秒全属性')
			local int = hero:get('每秒智力') + hero:get('每秒全属性')
			local agi = hero:get('每秒敏捷') + hero:get('每秒全属性')
			local defence = hero:get('每秒护甲') 
			hero:add('力量',str)
			hero:add('智力',int)
			hero:add('敏捷',agi)
			hero:add('护甲',defence)
		end	
	end	
end)