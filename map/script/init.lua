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

    -- ac.item.create_item('短剑',ac.point(500,500))
    -- ac.item.create_item('假腿',ac.point(500,500))
    -- ac.item.create_item('生锈剑',ac.point(500,500))
    -- ac.item.create_item('锈枪',ac.point(500,500))
    -- ac.item.create_item('仙女魔杖',ac.point(500,500))
    -- ac.item.create_item('亡灵之爪',ac.point(500,500))
    -- ac.item.create_item('木制假腿',ac.point(500,500))
    -- ac.item.create_item('爱情药剂',ac.point(500,500))
    -- ac.item.create_item('敏捷仙丹',ac.point(500,500))
    -- ac.item.create_item('敏捷仙丹',ac.point(500,500))
    -- ac.item.create_item('敏捷仙丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
    -- ac.item.create_item('敏捷丹',ac.point(500,500))
     ac.item.create_item('迷你羊石',ac.point(0,0))
     ac.item.create_item('幸运石',ac.point(0,0))
     ac.item.create_item('圣甲虫石',ac.point(0,0))
     ac.item.create_item('空瓶',ac.point(0,0))
     ac.item.create_item('迷你熊爪',ac.point(0,0))

    -- local items = ac.item.create_item('变色龙之斧',ac.point(0,0))

    --测试art
    -- local art = "item\\xie101.blp"
    -- ac.wait(0.1*1000,function()
    --     items:set_art(art)
    -- end)
    
    -- u:add_item('霹雳弩')
    -- u:add_item('厄运斧')
    -- u:add_item('腰带')
    -- u:add_item('寻觅丹')
    -- u:add_item('投射弩')
    -- ac.item.create_item('新手剑+1')

    -- u:add_item('新手剑+2')
    -- ac.dummy_hero = ac.player(16):createHero('小黑',ac.point(0,0))
    -- ac.item.create_skill_item('粉碎',ac.point(-300,0))
    -- ac.item.create_skill_item('贪婪者的心愿',ac.point(-300,0))
    -- ac.item.create_skill_item('贪婪者的心愿',ac.point(-300,0))
    -- ac.item.add_skill_item('粉碎',u)
    -- ac.item.create_skill_item('粉碎',ac.point(-300,0))
    -- ac.item.create_skill_item('粉碎',ac.point(-300,0))
    -- ac.item.create_skill_item('粉碎',ac.point(-300,0))
    -- ac.item.create_skill_item('穿刺',ac.point(-300,0))
    -- ac.item.create_skill_item('穿刺',ac.point(-300,0))
    -- ac.item.create_skill_item('穿刺',ac.point(-300,0))
    -- ac.item.create_skill_item('贪婪者的心愿',ac.point(-300,0))
    -- ac.item.create_skill_item('贪婪者的心愿',ac.point(-300,0))
    ac.game:event '游戏-开始' (function()
    
    end)

    
end);