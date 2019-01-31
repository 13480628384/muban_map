
g_game_min = 1

ac.game:event '游戏-开始' (function()

    ac.loop(60*1000,function()
        g_game_min = g_game_min +1
    end)
     
end)    