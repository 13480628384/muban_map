base = require 'base'
japi = require 'jass.japi'
jass = require 'jass.common'
storm = require 'jass.storm'
require 'util'
require 'war3'
require 'types'
require 'ac'
require '通用'
require '物品'
require '技能'
require '英雄'
-- require '野怪'

local u = ac.player[1]:createHero('黑暗游侠',ac.point(0,0))
local p = ac.player[1]
p.hero = u

p:event_notify('玩家-注册英雄', p, u)
p:addGold(1000000)

local item = ac.item.create_item('新手剑')
u:add_item(item)
-- local item = ac.item.create_item('新手弓')
-- u:add_item(item)

ac.item.create_item('新手剑',ac.point(500,500))
ac.item.create_item('新手弓',ac.point(500,500))
ac.item.create_item('新手石',ac.point(500,500))
ac.item.create_item('新手石',ac.point(500,500))
ac.item.create_item('新手石',ac.point(500,500))
ac.item.create_item('新手石',ac.point(500,500))
ac.item.create_item('新手石',ac.point(500,500))
ac.item.create_item('新手石',ac.point(500,500))
ac.item.create_item('新手石',ac.point(500,500))
ac.item.create_item('新手剑',ac.point(500,500))
ac.item.create_item('新手剑',ac.point(500,500))
ac.item.create_item('新手戒指',ac.point(500,500))
ac.item.create_item('新手戒指',ac.point(500,500))
ac.item.create_item('新手甲',ac.point(500,500))
ac.item.create_item('新手甲',ac.point(500,500))

ac.item.create_item('新手剑+1',ac.point(200,500))
ac.item.create_item('新手剑+1',ac.point(200,500))

u:add_item('新手剑+1')
u:add_item('新手甲')
u:add_item('新手戒指')
-- ac.item.create_item('新手剑+1')

-- u:add_item('新手剑+2')

local u = ac.shop.create('商店A',0,0)
ac.item.create_item('力量之书',ac.point(100,100))
