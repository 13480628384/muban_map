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
require 'war3'
require 'types'
require 'ac'
require 'ui'
require '通用'
require '游戏'
require '物品'
require '技能'
require '英雄'
require '刷怪'
require '平台'
require '测试'

ac.wait(100,function ()
   
    
    -- local item = ac.item.create_item('新手剑')
    
    -- ac.game:event '游戏-开始' (function()
    
    -- end)

    
end);