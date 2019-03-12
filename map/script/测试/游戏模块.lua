
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


-- ac.game:event '单位-死亡'(function(self,unit,killer)
--     ac.timer(0.1*1000,1,function()
--         ac.item.create_item('神奇护腰',unit:get_point())
    
--     end)
-- end)
-- local unit = ac.player(12):create_unit('凯撒(恶魔形态)',ac.point(1000,1000))
-- -- unit:set_size(2)
-- unit:add('生命上限',20000)
-- local unit = ac.player(1):create_unit('死骑',ac.point(1000,1000),270)
-- unit:set_size(2.5)
-- unit:add('生命上限',20000)
-- unit:add('移动速度',400)
-- -- unit:setColor(100,100,100)
-- -- unit:setColor(68,68,68)
-- unit:add_buff '时停'
-- {
-- 	time = 30,
-- 	skill = '游戏模块',
-- 	source = unit,
-- 	show = true
-- }


-- local u = ac.player(2):createHero('小黑',ac.point(1100,1100))
-- local p = ac.player(2)
-- p.hero = u
-- print(u.unit_type)
-- u:add('生命上限',20000)

--输入 over 游戏结束
ac.game:event '玩家-聊天' (function(self, player, str)
    local hero = player.hero
	local p = player
	
    if str == 'over' then
		ac.game:event_notify('游戏-结束')
	end    
end)	
