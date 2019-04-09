local multiboard = require 'types.multiboard'

local base_icon = [[ReplaceableTextures\CommandButtons\BTNSelectHeroOn.blp]]
local mtb
ac.game.multiboard = mtb

local list1 = {'玩家ID','所选英雄','杀敌','伤害'}
local function multiboard_init()
	local online_player_cnt = get_player_count()
	local all_lines = online_player_cnt +3
	mtb = multiboard.create(4,all_lines)
	ac.game.multiboard = mtb

	--初始化格式
	mtb:setAllStyle(true,false)
	for y = 1,all_lines do
		for x = 1,4 do 
			if y == 1 then
				mtb:setText(x,y,list1[x])
			elseif y == (all_lines - 1) then
				mtb:setStyle(x,y,false,false)
			end

			if x == 1 then
				if y >= 2 and y <= (all_lines - 2) then
					mtb:setText(x,y,'玩家' .. y - 1)
				end
				mtb:setWidth(x,y,0.06)
			elseif x == 2 then
				if y >= 2 and y <= (all_lines - 2) then
					mtb:setStyle(x,y,true,true)
				end
				mtb:setWidth(x,y,0.05)
				mtb:setIcon(x,y,base_icon)
			elseif x == 3 then
				if y >= 2 and y <= (all_lines - 2) then
					mtb:setText(x,y,0)
				end
				mtb:setWidth(x,y,0.04)
			elseif x == 4 then
				if y >= 2 and y <= (all_lines - 2) then
					mtb:setText(x,y,0)
				end
				mtb:setWidth(x,y,0.04)
			end
			
		end
	end
	mtb:setText(1,all_lines,'按住|cffff0000tab|r查看详细数据')

	--玩家信息初始化，设置英雄头像，玩家信息
	ac.game.multiboard.player_init = function(player,hero)
		mtb:setText( 1, player.id + 1, player:get_name()..(player.unlucky and '(衰人)' or '' ))
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

	ac.game.multiboard.set_time = function(time)
		local title = ""
		if ac.g_game_mode == 1 then 
			title = '标准模式'
		else
			title = '嘉年华模式'
		end	
		mtb:setTitle(title .. '          游戏剩余时间 ' .. time)
	end
	--怪物总数
	local creep_num = 0
	ac.game.multiboard.creep_count = function(num)
		creep_num = creep_num + num
		mtb:setText(4,all_lines,creep_num)
	end
end


ac.wait(10,function()
	multiboard_init()
	mtb:show()
end)