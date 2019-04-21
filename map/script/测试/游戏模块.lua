
local player = require 'ac.player'
local fogmodifier = require 'types.fogmodifier'
local sync = require 'types.sync'
local jass = require 'jass.common'
local hero = require 'types.hero'
local item = require 'types.item'
local affix = require 'types.affix'
local japi = require 'jass.japi'
local japi = require 'jass.japi'
local rect = require 'types.rect'

--创建全图视野
local function icu()
	fogmodifier.create(ac.player(1), ac.map_area)
end
icu()

-- local u = ac.player(16):create_unit('挑战怪10',ac.point(100,200))
-- u:set('生命上限',2000)
-- u:set('移动速度',300)

--输入 over 游戏结束
ac.game:event '玩家-聊天' (function(self, player, str)
    local hero = player.hero
	local p = player
	
    if str == 'qlwp' then
		--开始清理物品
		local tbl = {}
		for _,v in pairs(ac.item.item_map) do

			if not v.owner  then 
				table.insert(tbl,v)
			end	
		end

		table.sort(tbl,function (a,b)
			local p = ac.point(0,0)
			return a:get_point() * p <  b:get_point() * p
		end)

		for index,item in ipairs(tbl) do 
			item:item_remove()
		end 
	end  
end)	
