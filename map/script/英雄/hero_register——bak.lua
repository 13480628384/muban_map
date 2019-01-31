local jass = require 'jass.common'
local heror = require 'types.hero'
local unit = require 'types.unit'


local id_name = {'A','B','C','D','E','F','G','H','I','J','K','L'}
local sq = {'A00C','A00D','A002','A003','A004','A005','A006','A007','A008','A009','A00A','A00B'}
for i = 1, 12 do
	local p = ac.player[i]
	p.ability_list = {}
	p.ability_list['英雄'] = {}
	p.ability_list['宠物'] = {}
	p.ability_list['召唤'] = {}
	p.ability_list['拾取'] = {}

	p.ability_list['拾取'][1] = sq[i]
	p.ability_list['切换背包-玩家'] = {}
	p.ability_list['切换背包-宠物'] = {}
	for t=1,2 do
		for n=1,7 do
			if t == 1 then
				--英雄技能模板
				local id = 'A'..id_name[i]..'0'..n
				p.ability_list['英雄'][n] = id
			else
				--宠物技能模板
				local id = 'A'..id_name[i]..'1'..n
				p.ability_list['宠物'][n] = id
			end
		end

		local id = 'AZ'..id_name[i]..t
		if t == 1 then
			p.ability_list['切换背包-玩家'][1] = id
		else
			p.ability_list['切换背包-宠物'][1] = id
		end

	end
end


local function hero_register_main()
	--注册英雄
	ac.game:event '玩家-注册英雄' (function(_, player, hero)
		SelectUnitForPlayerSingle(hero.handle,player.handle)
		--添加技能
		hero:add_all_hero_skills()

		hero:add_skill('拾取','拾取',1)
		hero:add_skill('切换背包','切换背包-玩家',1)
		--创建一个宠物
		player:create_pets()
	end)
end

hero_register_main()
