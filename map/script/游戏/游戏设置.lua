
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
    ['XX商店'] =rect.j_rect('xxsd') ,
    ['出生点'] =rect.j_rect('csd') ,
}
ac.map['刷怪中心点'] = rect.j_rect('sg002'):get_point()

-- local minx, miny, maxx, maxy = ac.map.rects['刷怪']:get()
-- local point = rect.j_rect('sg002'):get_point()
-- print(minx, miny, maxx, maxy)