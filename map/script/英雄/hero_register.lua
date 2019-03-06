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
--玩家16 技能预览图
local i =16
if i == 16 then
	local p = ac.player[i]
	p.ability_list = {}
	p.ability_list['预览'] = {size = 4}
	for x = 1, p.ability_list['预览'].size do
		p.ability_list['预览'][x] = ('Q20%d'):format(x - 1)
	end
	
end

local function hero_register_main()
	--注册英雄
	ac.game:event '玩家-注册英雄' (function(_, player, hero)
		SelectUnitForPlayerSingle(hero.handle,player.handle)
		--创建一个背包表
		hero.item_list = {}
		--记录当前页面
		hero.currentpage = 1

		-- 统一设置搜敌范围
		hero:set_search_range(1000)
		--添加技能
		hero:add_all_hero_skills()

		hero:add_skill('拾取','拾取',1)
		-- hero:add_skill('切换背包','英雄',5)
		-- hero:add_skill('测试','英雄')
		hero:add_skill('闪烁','英雄')
		-- hero:add_skill('弹射','英雄')
		-- hero:add_skill('F4战斗机','英雄')
		-- hero:add_skill('缠绕','英雄')
		-- hero:add_skill('风暴锤子','英雄')
		-- hero:add_skill('击地','英雄')
		-- hero:add_skill('穿刺','英雄')
		-- hero:add_skill('时间静止','英雄')
		-- hero:add_skill('妖刀','英雄')
		-- hero:add_skill('静止陷阱','英雄')
		-- hero:add_skill('荆棘光环','英雄')
		-- hero:add_skill('强击光环','英雄')
		-- hero:add_skill('辉煌光环','英雄')
		-- hero:add_skill('自然之力','英雄')
		-- hero:add_skill('水元素','英雄')
		-- hero:add_skill('影子','英雄')
		 hero:add_skill('愤怒','英雄')
		-- hero:add_skill('硬币机器','英雄')
		-- hero:add_skill('张全蛋','英雄')
		-- hero:add_skill('狂猛','英雄')
		-- hero:add_skill('群体治疗','英雄')
		-- hero:add_skill('治疗守卫','英雄')
		-- hero:add_skill('冰甲','英雄')
		-- hero:add_skill('心灵之火','英雄')
		-- hero:add_skill('闪电手','英雄')
		-- hero:add_skill('愤怒','英雄')
		-- hero:add_skill('爱屋及乌','英雄')
		-- hero:add_skill('献祭','英雄')
		-- hero:add_skill('阳光枪','英雄')
		-- hero:add_skill('火焰雨','英雄')
		-- hero:add_skill('巨浪','英雄')
		-- hero:add_skill('飞焰','英雄')
		-- hero:add_skill('炎爆术','英雄')
		--  hero:add_skill('暴击','英雄')
		-- hero:add_skill('闪电链','英雄')
		-- hero:add_skill('暴风雪','英雄')
		-- hero:add_skill('属性转换','英雄')
		-- hero:add_skill('死亡之指','英雄')
		-- hero:add_skill('死亡脉冲','英雄')
		-- hero:add_skill('痛苦尖叫','英雄')
		-- hero:add_skill('光明契约','英雄')
		-- hero:add_skill('摔破罐子','英雄')
		-- hero:add_skill('刀刃旋风','英雄')
		-- hero:add_skill('黑暗契约','英雄')
		-- hero:add_skill('死亡飞镖','英雄')
		
		
		-- hero:add('物品获取率',50)
    	-- ac.item.add_skill_item('巨浪',hero)
    	-- ac.item.add_skill_item('巨浪',hero)
    	-- ac.item.add_skill_item('巨浪',hero)
         ac.item.add_skill_item('F4战斗机',hero)
        -- ac.item.add_skill_item('粉碎',hero)
        -- ac.item.add_skill_item('贪婪者的心愿',hero)
        -- ac.item.add_skill_item('贪婪者的心愿',hero)
        -- ac.item.add_skill_item('穿刺',hero)
        -- ac.item.add_skill_item('穿刺',hero)
        -- ac.item.add_skill_item('魔王降临',hero)
		
		hero:add_item('新人寻宝石') 
		hero:add_item('新人寻宝石') 
		hero:add_item('新人寻宝石') 
		hero:add_item('新人寻宝石') 

		-- hero:add_item('勇气之证')
		--添加英雄属性面板
		hero:add_skill('英雄属性面板', '隐藏')

		--创建一个宠物
		player:create_pets()
	end)

end

hero_register_main()



ac.game:event '玩家-选择单位' (function(self, player, hero)
	if hero:get_owner() ~= player then 
		return 
	end 
	player.selected = hero 
	for skill in hero:each_skill '英雄' do 
		skill:fresh()
	end 

end)