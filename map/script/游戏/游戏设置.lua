
--游戏全局设置
--ac.rect.map 全图 rect.create(-4000,-4000,4000,4000) or
local rect = require("types.rect")
local region = require("types.region")

ac.map = {}
ac.map_area =  ac.rect.map
ac.map.rects={
    ['刷怪'] = region.create(rect.j_rect('sg001'),rect.j_rect('sg002'),rect.j_rect('sg003'),rect.j_rect('sg004')),
    ['选人区域'] =rect.j_rect('xr') ,
    ['物品商店'] =rect.j_rect('wpsd') ,
    ['技能商店'] =rect.j_rect('jnsd') ,
    ['积分商店'] =rect.j_rect('jfsd') ,
    ['图书馆'] =rect.j_rect('xxsd') ,
    ['出生点'] =rect.j_rect('csd') ,
}
ac.map['刷怪中心点'] = rect.j_rect('sg002'):get_point()

-- local minx, miny, maxx, maxy = ac.map.rects['刷怪']:get()
-- local point = rect.j_rect('sg002'):get_point()
-- print(minx, miny, maxx, maxy)


--召唤物倍数
local function get_summon_mul(lv)
	local level_mul = {
		[10] ={ 
			['最小范围'] = 0,
			['生命'] = 5, 
			['护甲'] = 0.05, 
			['攻击'] = 5, 
		},
		[25] ={ 
			['最小范围'] = 10,
			['生命'] = 6, 
			['护甲'] = 0.05, 
			['攻击'] = 7.5, 
		},
		[45] ={ 
			['最小范围'] = 25,
			['生命'] = 7, 
			['护甲'] = 0.05, 
			['攻击'] = 10, 
		},
		[70] ={ 
			['最小范围'] = 45,
			['生命'] = 8, 
			['护甲'] = 0.05, 
			['攻击'] = 12.5, 
		},
		[100] ={ 
			['最小范围'] = 70,
			['生命'] = 9, 
			['护甲'] = 0.05, 
			['攻击'] = 15, 
		},
	}

	local life_mul = 1
	local defence_mul = 1
	local attack_mul = 1
	for index,info in pairs(level_mul) do 
		if lv <= index and lv > info['最小范围']  then 
			life_mul = info['生命']
			defence_mul = info['护甲']
			attack_mul = info['攻击']
			break 
		end 
	end 
	return life_mul,defence_mul,attack_mul
end	

ac.get_summon_mul = get_summon_mul

