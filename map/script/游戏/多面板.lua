local multiboard = require 'types.multiboard'

local base_icon = [[ReplaceableTextures\CommandButtons\BTNSelectHeroOn.blp]]
local mtb
ac.game.multiboard = mtb

local list1 = {'玩家ID','所选英雄','杀敌','伤害'}
local function multiboard_init()
	local online_player_cnt = get_player_count()
	local all_lines = online_player_cnt +3
	all_lines = 8
	mtb = multiboard.create(5,all_lines)
	ac.game.multiboard = mtb

	--初始化格式
	mtb:setAllStyle(true,false)
	for y = 1,all_lines do
		for x = 1,8 do 
			-- if y == 1 then
			-- 	mtb:setText(x,y,list1[x])
			-- elseif y == (all_lines - 1) then
			-- 	mtb:setStyle(x,y,false,false)
			-- end

			if x == 1 then
				-- if y >= 2 and y <= (all_lines - 2) then
				-- 	mtb:setText(x,y,'玩家' .. y - 1)
				-- end
				mtb:setWidth(x,y,0.07)
			elseif x == 2 then
				-- if y >= 2 and y <= (all_lines - 2) then
				-- 	mtb:setStyle(x,y,true,true)
				-- end
				mtb:setWidth(x,y,0.1)
				-- mtb:setIcon(x,y,base_icon)
			elseif x == 3 then
				-- if y >= 2 and y <= (all_lines - 2) then
				-- 	mtb:setText(x,y,0)
				-- end
				mtb:setWidth(x,y,0.01)
			elseif x == 4 then
				-- if y >= 2 and y <= (all_lines - 2) then
				-- 	mtb:setText(x,y,0)
				-- end
				mtb:setWidth(x,y,0.01)
			elseif x == 5 then
				-- if y >= 2 and y <= (all_lines - 2) then
				-- 	mtb:setText(x,y,0)
				-- end
				mtb:setWidth(x,y,0.01)	
			elseif x == 6 then
				-- if y >= 2 and y <= (all_lines - 2) then
				-- 	mtb:setText(x,y,0)
				-- end
				mtb:setWidth(x,y,0.01)	
			elseif x == 7 then
				-- if y >= 2 and y <= (all_lines - 2) then
				-- 	mtb:setText(x,y,0)
				-- end
				mtb:setWidth(x,y,0.01)	
			elseif x ==8 then
				-- if y >= 2 and y <= (all_lines - 2) then
				-- 	mtb:setText(x,y,0)
				-- end
				mtb:setWidth(x,y,0.01)	
			end

			
			
		end
	end
	
	mtb:setText(1,5,'按|cffff0000tab|r看|cffff0000当局排行榜|r')

	mtb:setText(1,6,'按|cffff0000F4|r 看|cffff0000历史排行榜|r')

	mtb:setText(1,7,'按|cffff0000F5|r 看|cffff0000今日排行榜|r')

	-- mtb:setWidth(1,all_lines,20)
	
	-- --玩家信息初始化，设置英雄头像，玩家信息
	ac.game.multiboard.player_init = function(player,hero)
		-- mtb:setText( 1, player.id + 1, player:get_name()..(player.unlucky and '(衰人)' or '' ))
		-- mtb:setText( 2, player.id + 1, hero:get_name())
		-- mtb:setIcon( 2, player.id + 1, hero:get_slk('Art',base_icon))
	end
	

	-- --杀害野怪刷新
	ac.game.multiboard.player_kill_count = function( player, num)
		-- mtb:setText( 3, player.id + 1, num)
	end

	-- --玩家伤害数据刷新
	local damage_list = {}
	ac.game.multiboard.damage_init = function(player, num)
		-- mtb:setText( 4, player.id + 1, num )
	end

	ac.game.multiboard.set_time = function(time)
		local tip =''  
		local degree 
		if ac.g_game_degree == 1 then 
			degree = '普通'
		elseif ac.g_game_degree == 2 then 
			degree = '噩梦'
		elseif ac.g_game_degree == 3 then  
			degree = '地狱'
		else 
			degree = '圣人'
		end  
		local name 
		if ac.g_game_mode == 1 then 
			name = '标准模式'..tip
		else 
			name = '嘉年华模式'..tip
		end  
		name = name ..'（'.. degree..'）'
		mtb:setTitle(name .. '           游戏剩余时间   ' .. time)
	end

	-- mtb:setText(2,2,'怪物总数')
	--怪物总数
	
	ac.loop(1*1000,function()
		local current_count = 0
		if ac.creep['刷怪'].index>=1 then
			current_count = ac.creep['刷怪'].current_count 
		end	
		if ac.creep['刷怪-无尽'].index>=1 then
			current_count = ac.creep['刷怪-无尽'].current_count 
		end	
		mtb:setText(1,2,'|cffffe799怪物总数：|r'..current_count)

		--设置倒计时
		if ac.creep['刷怪'] and ac.creep['刷怪'].boss then  
			local buff = ac.creep['刷怪'].boss:find_buff '时停'
			if buff then 
				--最终boss死亡之指倒计时 
				mtb:setText(1,3,'|cffffe799BOSS大招倒计时：|r|cffff0000'..(buff.time-1)..'|r')
				mtb:setText(2,3,'|cffff0000'..(buff.time-1)..'|r')
			end	
		end	 
	end)

	
end


ac.wait(10,function()
	multiboard_init()
	mtb:show()
end)