base = require 'base'
japi = require 'jass.japi'
jass = require 'jass.common'
storm = require 'jass.storm'
require 'util'
require 'war3'
require 'types'
require 'ac'
require '通用'
require '游戏'
require '物品'
require '技能'
require '英雄'
require '野怪'
require '测试'


ac.wait(100,function ()
    -- local u = ac.player[1]:createHero('小黑',ac.point(0,0))
    -- local p = ac.player[1]
    -- p.hero = u
    -- p:addGold(1000000)
    -- p:event_notify('玩家-注册英雄', p, u)
    
    -- ac.game:event_notify('游戏-开始')
    
    local item = ac.item.create_item('新手剑')
    -- u:add_item(item)
    -- local item = ac.item.create_item('新手弓')
    -- u:add_item(item)

    -- ac.item.create_item('新手剑',ac.point(500,500))
    -- ac.item.create_item('新手弓',ac.point(500,500))
    -- ac.item.create_item('新手石',ac.point(500,500))
    -- ac.item.create_item('新手石',ac.point(500,500))
    -- ac.item.create_item('新手石',ac.point(500,500))
    -- ac.item.create_item('新手石',ac.point(500,500))
    -- ac.item.create_item('新手石',ac.point(500,500))
    -- ac.item.create_item('新手石',ac.point(500,500))
    -- ac.item.create_item('新手石',ac.point(500,500))
    -- ac.item.create_item('新手剑',ac.point(500,500))
    -- ac.item.create_item('新手剑',ac.point(500,500))
    -- ac.item.create_item('新手戒指',ac.point(500,500))
    -- ac.item.create_item('新手戒指',ac.point(500,500))
    -- ac.item.create_item('新手甲',ac.point(500,500))
    -- ac.item.create_item('新手甲',ac.point(500,500))

    -- ac.item.create_item('新手剑+1',ac.point(200,500))
    -- ac.item.create_item('新手剑+1',ac.point(200,500))

    ac.item.create_item('短剑',ac.point(500,500))
    ac.item.create_item('假腿',ac.point(500,500))
    ac.item.create_item('生锈剑',ac.point(500,500))
    ac.item.create_item('锈枪',ac.point(500,500))
    ac.item.create_item('仙女魔杖',ac.point(500,500))
    ac.item.create_item('亡灵之爪',ac.point(500,500))
    ac.item.create_item('木制假腿',ac.point(500,500))
    ac.item.create_item('敏捷仙丹',ac.point(500,500))
    ac.item.create_item('敏捷仙丹',ac.point(500,500))
    ac.item.create_item('敏捷仙丹',ac.point(500,500))
    ac.item.create_item('敏捷仙丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('敏捷丹',ac.point(500,500))
    ac.item.create_item('霹雳弩',ac.point(0,0))
    ac.item.create_item('变色龙之斧',ac.point(0,0))

    -- u:add_item('霹雳弩')
    -- u:add_item('厄运斧')
    -- u:add_item('腰带')
    -- u:add_item('寻觅丹')
    -- u:add_item('投射弩')
    -- ac.item.create_item('新手剑+1')

    -- u:add_item('新手剑+2')

    local u = ac.shop.create('商店A',0,0)
    ac.item.create_item('力量之书',ac.point(100,100))

end);