base = require 'base'
japi = require 'jass.japi'
jass = require 'jass.common'
storm = require 'jass.storm'
dzapi = require 'jass.dzapi'
--官方存档和商城
mtp_dzapi = {}
for key, value in pairs(dzapi) do
    mtp_dzapi[key] = value
end
require 'util'
print(1)
require 'war3'
print(2)
require 'types'
print(3)
require 'ac'
print(4)
require 'ui'
print(5)
require '通用'
print(6)
require '游戏'
print(7)
require '物品'
print(8)
require '技能'
print(9)
require '英雄'
print(10)
require '刷怪'
print(11)
-- require '平台'
print(12)
require '测试'
print(13)
--设置天空模型
-- jass.SetSkyModel([[sky.mdx]])
-- jass.CreateDestructable(base.string2id('B04E'), 0, 0, 0, 1, 0)
ac.wait(100,function ()
   
    
    -- local item = ac.item.create_item('新手剑')
    
    ac.game:event '游戏-开始' (function()
        --  local item = ac.item.create_item('小兔子')
        --  local item = ac.item.create_item('小兔子')
        --  local item = ac.item.create_item('小兔子')
        --  local item = ac.item.create_item('小兔子')
        --  local item = ac.item.create_item('小兔子')
        --  local item = ac.item.create_item('小兔子')
        -- local item = ac.item.create_item('生锈剑')
        -- local item = ac.item.create_item('知识丹')
        -- local item = ac.item.create_item('寻觅丹')
        -- local item = ac.item.create_item('生锈剑')
        -- local item = ac.item.create_item('生锈剑')
        -- local item = ac.item.create_item('寻觅丹')
        -- local item = ac.item.create_item('寻觅丹')
        -- local item = ac.item.create_item('生锈剑')
        -- local item = ac.item.create_item('生锈剑')
        -- local item = ac.item.create_item('生锈剑')
        -- local item = ac.item.create_skill_item('万箭齐发')
        -- local item = ac.item.create_skill_item('万箭齐发')
        -- local item = ac.item.create_skill_item('御甲')
        -- local item = ac.item.create_skill_item('御甲')
    end)

    
end);