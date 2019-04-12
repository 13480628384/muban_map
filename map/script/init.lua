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
-- print(1)
require 'war3'
-- print(2)
require 'types'
-- print(3)
require 'ac'
-- print(4)
require 'ui'
-- print(5)
require '通用'
-- print(6)
require '游戏'
-- print(7)
require '物品'
-- print(8)
require '技能'
-- print(9)
require '英雄'
-- print(10)
require '刷怪'
-- print(11)
require '平台'
-- print(12)
require '测试'
-- print(13)
--设置天空模型
-- jass.SetSkyModel([[sky.mdx]])
-- jass.CreateDestructable(base.string2id('B04E'), 0, 0, 0, 1, 0)


ac.wait(100,function ()
    local function light(type)
        local light = {
            'Ashenvale',
            'Dalaran',
            'Dungeon',
            'Felwood',
            'Lordaeron',
            'Underground',
        }
        if not tonumber(type) or tonumber(type) > #light or tonumber(type) < 1 then
            return
        end
        local name = light[tonumber(type)]
        jass.SetDayNightModels(([[Environment\DNC\DNC%s\DNC%sTerrain\DNC%sTerrain.mdx]]):format(name, name, name), ([[Environment\DNC\DNC%s\DNC%sUnit\DNC%sUnit.mdx]]):format(name, name, name))
    end
    -- light(3)
   
    -- local item = ac.item.create_item('新手剑')
    --设置联盟模式
    -- jass.SetAllyColorFilterState(1)
    ac.game:event '游戏-开始' (function()
        -- local item = ac.item.create_item('生锈剑')
        -- local item = ac.item.create_skill_item('万箭齐发')
    end)

    
end);