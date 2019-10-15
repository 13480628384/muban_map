local player = require 'ac.player'
local japi = require 'jass.japi'
local jass = require 'jass.common'
local dzapi = require 'jass.dzapi'
record_11 = true
register_japi([[
native  InitGameCache    takes string campaignFile returns gamecache
native  SaveGameCache    takes gamecache whichCache returns boolean

native EXNetUseItem  takes player player_id,string itemid,integer amount returns boolean

native  StoreInteger					takes gamecache cache, string missionKey, string key, integer value returns nothing
native  StoreReal						takes gamecache cache, string missionKey, string key, real value returns nothing
native  StoreBoolean					takes gamecache cache, string missionKey, string key, boolean value returns nothing
native  StoreUnit						takes gamecache cache, string missionKey, string key, unit whichUnit returns boolean
native  StoreString						takes gamecache cache, string missionKey, string key, string value returns boolean

native SyncStoredInteger        takes gamecache cache, string missionKey, string key returns nothing
native SyncStoredReal           takes gamecache cache, string missionKey, string key returns nothing
native SyncStoredBoolean        takes gamecache cache, string missionKey, string key returns nothing
native SyncStoredUnit           takes gamecache cache, string missionKey, string key returns nothing
native SyncStoredString         takes gamecache cache, string missionKey, string key returns nothing

native  HaveStoredInteger					takes gamecache cache, string missionKey, string key returns boolean
native  HaveStoredReal						takes gamecache cache, string missionKey, string key returns boolean
native  HaveStoredBoolean					takes gamecache cache, string missionKey, string key returns boolean
native  HaveStoredUnit						takes gamecache cache, string missionKey, string key returns boolean
native  HaveStoredString					takes gamecache cache, string missionKey, string key returns boolean

native  FlushGameCache						takes gamecache cache returns nothing
native  FlushStoredMission					takes gamecache cache, string missionKey returns nothing
native  FlushStoredInteger					takes gamecache cache, string missionKey, string key returns nothing
native  FlushStoredReal						takes gamecache cache, string missionKey, string key returns nothing
native  FlushStoredBoolean					takes gamecache cache, string missionKey, string key returns nothing
native  FlushStoredUnit						takes gamecache cache, string missionKey, string key returns nothing
native  FlushStoredString					takes gamecache cache, string missionKey, string key returns nothing

native  GetStoredInteger				takes gamecache cache, string missionKey, string key returns integer
native  GetStoredReal					takes gamecache cache, string missionKey, string key returns real
native  GetStoredBoolean				takes gamecache cache, string missionKey, string key returns boolean
native  GetStoredString					takes gamecache cache, string missionKey, string key returns string
native  RestoreUnit						takes gamecache cache, string missionKey, string key, player forWhichPlayer, real x, real y, real facing returns unit
]])

local has_record = not not japi.InitGameCache
log.debug('积分环境', has_record)

local names = {
	'FlushGameCache',
	'InitGameCache',
	'StoreInteger',
	'GetStoredInteger',
	'StoreString',
	'SaveGameCache',
    'SyncStoredInteger',
    'HaveStoredInteger',
}
for _, name in ipairs(names) do
	if not japi[name] then
		rawset(japi, name, jass[name])
	end
end

local function get_key(player)
	return ("ABCDEFGHIJKLMNOPQRSTUVWXYZ"):sub(player:get(),player:get())
end

--获取积分对象
function ac.player.__index:record()
	if not self.record_data then
		if self:is_player() then
			self.record_data = japi.InitGameCache('11billing@' .. get_key(self))
		else
			self.record_data = japi.InitGameCache('')
		end
	end
	return self.record_data
end

--判断玩家是否有商城道具(用来做判断皮肤，人物，地图内特权VIP)等等
function ac.player.__index:Map_HasMallItem(key)
    if has_record then
		return japi.HaveStoredInteger(self:record(), "状态", key) 
	end
	print('warning: has_record为空')
    --测试时，默认都为空
	return false
end

--扣除玩家一个次数类道具（例如逃跑清除卡，使用后道具 - 1）扣除成功后返回true 失败返回false
function ac.player.__index:sub_item(key,i)
	return japi.EXNetUseItem(self.handle,key,i)
end



-- RPG积分相关
local score_gc
local function get_score()
	if not score_gc then
		japi.FlushGameCache(japi.InitGameCache("11.x"))
		score_gc = japi.InitGameCache("11.x")
	end
	return score_gc
end

local current_player
local function get_player()
	if current_player and current_player:is_player() then
		return current_player
	end
	for i = 1, 12 do
		if ac.player[i]:is_player() then
			current_player = ac.player[i]
			return current_player
		end
	end
	return ac.player[1]
end

local function write_score(table, key, data)
	japi.StoreInteger(get_score(), table, key, data)
	if get_player():is_self() then
		japi.SyncStoredInteger(get_score(), table, key)
	end
end

local function read_score(table, key)
	return japi.GetStoredInteger(get_score(), table, key)
end

local score = {}

function ac.player.__index:Map_GetServerValue(name)
	if not score[name] then
		score[name] = {}
	end
	if not score[name][self.id] then
		score[name][self.id] = read_score(get_key(self), name)
	end
	log.debug(('获取RPG积分:[%s][%s] --> [%s]'):format(self:get_name(), name, score[name][self.id]))
	return tonumber(score[name][self.id]) or 0
end

function ac.player.__index:Map_SaveServerValue(name, value)
    value = tonumber(value)
	if not score[name] then
		score[name] = {}
    end
	score[name][self.id] = value
	log.debug(('设置RPG积分:[%s][%s] = [%s]'):format(self:get_name(), name, value))
	if has_record then
		write_score(get_key(self) .. "=", name, value)
	else
		write_score(get_key(self), name, value)
	end
end

function ac.player.__index:Map_AddServerValue(name, value)
    value = tonumber(value)
	local r = self:Map_GetServerValue(name) + value
	score[name][self.id] = r

	local type = '增加'
	if value < 0 then
		type = '减少'
	end

	log.debug((type..'RPG积分:[%s][%s] + [%s]'):format(self:get_name(), name, value))
	if has_record then
		write_score(get_key(self) .. "+", name, value)
	else
		write_score(get_key(self), name, value + self:Map_GetServerValue(name))
	end
end
--获取地图等级
function ac.player.__index:Map_GetMapLevel()
    local value = self:Map_GetServerValue 'level'
	log.debug(('获取RPG等级:[%s] --> [%s]'):format(self:get_name(), value))
	return value
end

function ac.game:score_game_end()
	write_score("$", "GameEnd", 0)
end

--自己模拟地图等级
ac.loop(60 * 1000,function()
    for i = 1,8 do
        local p = ac.player[i]
        if p:is_player() then
            p:Map_AddServerValue('exp',60) math.sqrt(16)
            -- p:Map_SaveServerValue('level',math.floor(tonumber(p:Map_GetServerValue 'exp') / 5000))
            p:Map_SaveServerValue('level',math.floor(math.sqrt(p:Map_GetServerValue('exp')/3600)+1)) --当前地图等级=开方（经验值/3600）+1
        end
    end
end)