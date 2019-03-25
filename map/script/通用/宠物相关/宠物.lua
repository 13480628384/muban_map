local player = require 'ac.player'

function player.__index:create_pets()
    local u = self:create_unit('n003',ac.point(-500,0))
    u.unit_type = '宠物'
    --添加切换背包
    u:add_skill('切换背包','英雄',5)
    u:add_restriction '无敌'
    u:add_restriction '缴械'
    u:add_skill('拾取','拾取',1)
    
    u:add_skill('全图闪烁','英雄')
    u:add_skill('传递物品','英雄')
    u:add_skill('一键拾取','英雄')
    u:add_skill('装备合成书','英雄')
    u:add_skill('地图等级','英雄',8)
    
    
end
