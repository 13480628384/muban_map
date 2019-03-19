local tips = {
    '【系统提示】游戏积分可以通过通关游戏或在无尽模式下获得，积分可以兑换海量道具',
    '【系统提示】宠物可以学习技能、使用药水，作用在英雄身上',
    '【系统提示】物理暴击或法术暴击，可以与会心暴击相叠加',
    '【系统提示】当地图内野怪数量超过200个时，游戏将会失败，请注意清怪。',
}

ac.loop(60 * 1000,function ()
    local rand = math.random(#tips)
    local tip = tips[rand]
    --提醒多次 3次
    tip = tip..'\r'..tip..'\r'..tip
    ac.player.self:sendMsg(tip,30)
end)