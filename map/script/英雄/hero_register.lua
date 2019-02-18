local jass = require 'jass.common'
local heror = require 'types.hero'
local unit = require 'types.unit'

--1-12为12个技能模板，如玩家1是AA01-AA12，玩家2是AB01-AB12
--排序
--[[
	9 10 11 12
	5 6 7 8
	1 2 3 4
	
	A S X C
	Z D F G
	Q W E R
]]

--13是拾取技能,AA13 AB13...

local id_name = {'A','B','C','D','E','F','G','H','I','J','K','L'}
for i = 1, 12 do
	local p = ac.player[i]
	p.ability_list = {}
	p.ability_list['英雄'] = {}
	p.ability_list['隐藏'] = {}
	p.ability_list['拾取'] = {}

	local n = 0

	for t=1,12 do
		local id = 'A'..id_name[i]
		if t < 10 then
			id = id .. '0'..t
		else
			id = id ..t
		end
		p.ability_list['英雄'][t] = id
	end
	p.ability_list['拾取'][1] = 'A'..id_name[i]..'13'
end


local function hero_register_main()
	--注册英雄
	ac.game:event '玩家-注册英雄' (function(_, player, hero)
		SelectUnitForPlayerSingle(hero.handle,player.handle)
		--创建一个背包表
		hero.item_list = {}
		--记录当前页面
		hero.currentpage = 1
		 
		--添加技能
		hero:add_all_hero_skills()

		hero:add_skill('拾取','拾取',1)
		hero:add_skill('切换背包','英雄',5)
		hero:add_skill('测试','英雄')
		hero:add_skill('闪烁','英雄')
		-- hero:add_skill('测试2','英雄')
		-- hero:add_skill('测试3','英雄')
		-- hero:add_skill('测试4','英雄')
		-- hero:add_skill('测试5','英雄')
		-- hero:add_skill('测试6','英雄')
		-- hero:add_skill('测试7','英雄')
		-- hero:add_skill('测试8','英雄')
		
		--添加英雄属性面板
		hero:add_skill('英雄属性面板', '隐藏')

		--创建一个宠物
		player:create_pets()
	end)
end

hero_register_main()
