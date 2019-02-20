
g_game_min = 1


ac.game:event '游戏-开始' (function()

    ac.loop(60*1000,function()
        g_game_min = g_game_min +1
    end)
    --游戏开始，不允许控制中立被动（钥匙怪）
    for x = 0, 10 do
        --不允许控制中立被动的单位
        ac.player.force[1][x]:disableControl(ac.player[16])
        ac.player.force[2][0]:disableControl(ac.player[16])
    end
    --每个玩家初始化金币
    for i=1 ,12 do 
        local p = ac.player(i)
        p:addGold(1000000)
    end    
     
end)    