require '刷怪.creep'
require '刷怪.刷怪'
require '刷怪.最终boss'
require '刷怪.刷怪-无尽'
require '刷怪.游戏结束'
require '刷怪.掉落'
require '刷怪.命运花'
require '刷怪.钥匙怪奖励'

-- require '野怪.BOSS-AI'

-- local mt = ac.creep['测试']{    
--     region = '',
--     creeps_datas = '强盗*40',
--     is_random = true,
--     creep_player = ac.player.com[2],
--     tip ="郊区野怪刷新啦，请速速打怪升级，赢取白富美"

-- }

-- function mt:on_start()
--     local rect = require 'types.rect'
--     local region = rect.create('-2000','-2000','2000','2000')
--     self.region = region
-- end

-- --改变怪物
-- function mt:on_change_creep(unit,lni_data)
--     unit:set('移动速度',400)
--     unit:set_search_range(99999)
-- end
-- mt:start()

-- 如下代码可以释放 内存
-- ac.loop(10*1000,function()
    -- for i=1,40 do 
    --     local unit = ac.player.com[2]:create_unit('强盗',ac.point(0,0))
    --     unit:set('生命上限',10000000000)
    --     unit:set('移动速度',400)
    --     unit:set_search_range(99999)
    -- end    
-- end)



