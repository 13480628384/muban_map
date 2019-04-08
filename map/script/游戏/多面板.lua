local multiboard = require 'types.multiboard'

local base_icon = [[ReplaceableTextures\CommandButtons\BTNSelectHeroOn.blp]]
local mtb
ac.game.multiboard = mtb

local list1 = {'玩家ID','所选英雄','杀敌','伤害'}
local function multiboard_init()
	mtb = multiboard.create(4,7)
	ac.game.multiboard = mtb

	--初始化格式
	mtb:setAllStyle(true,false)
	for y = 1,7 do
		for x = 1,4 do 
			if y == 1 then
				mtb:setText(x,y,list1[x])
			elseif y == 6 then
				mtb:setStyle(x,y,false,false)
			end

			if x == 1 then
				if y >= 2 and y <= 5 then
					mtb:setText(x,y,'玩家' .. y - 1)
				end
				mtb:setWidth(x,y,0.06)
			elseif x == 2 then
				if y >= 2 and y <= 5 then
					mtb:setStyle(x,y,true,true)
				end
				mtb:setWidth(x,y,0.05)
				mtb:setIcon(x,y,base_icon)
			elseif x == 3 then
				if y >= 2 and y <= 5 then
					mtb:setText(x,y,0)
				end
				mtb:setWidth(x,y,0.04)
			elseif x == 4 then
				if y >= 2 and y <= 5 then
					mtb:setText(x,y,0)
				end
				mtb:setWidth(x,y,0.04)
			end
			
		end
	end
	mtb:setText(1,7,'按住tab查看详细数据')

	--玩家信息初始化，设置英雄头像，玩家信息
	ac.game.multiboard.player_init = function(player,hero)
		mtb:setText( 1, player.id + 1, player.base_name)
		mtb:setText( 2, player.id + 1, hero:get_name())
		mtb:setIcon( 2, player.id + 1, hero:get_slk('Art',base_icon))
	end
	

	--杀害野怪刷新
	ac.game.multiboard.player_kill_count = function( player, num)
		mtb:setText( 3, player.id + 1, num)
	end

	--玩家伤害数据刷新
	local damage_list = {}
	ac.game.multiboard.damage_init = function(player, num)
		mtb:setText( 4, player.id + 1, num )
	end
	local tm = os.time() - 57600
	

	ac.loop(1*1000,function()
		local interval = os.time() - tm
		local title = "生存模式"
		local str = os.date("%H:%M:%S", interval)
		mtb:setTitle(title .. '          游戏时间 ' .. str)
		
		-- local list = get_player_list()
		-- for _,player in ipairs(list) do 
		-- 	if player == ac.player.self then 
		-- 		mtb:setText( 1, 7, '当前积分 ' .. (player.score or 0))
		-- 	end 
		-- end 
	end)

	--怪物总数
	local creep_num = 0
	ac.game.multiboard.creep_count = function(num)
		creep_num = creep_num + num
		mtb:setText(4,7,creep_num)
	end
end


ac.wait(10,function()
	multiboard_init()
	mtb:show()
end)