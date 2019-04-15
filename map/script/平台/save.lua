

function ac.jiami(p,key,value)
    local v = ZZBase64.decode(p[key])
    v = v  + value
    p[key] = ZZBase64.encode(v)

    ac.SaveServerValue(p,key,v)
end

--存档
function ac.SaveServerValue(p,KEY,value)
    value = tostring(value)
    local s = ZZBase64.encode(value)
    p:Map_SaveServerValue(KEY,s)
end

--读取
function ac.GetServerValue(p,KEY)
    local value = p:Map_GetServerValue(KEY)
    if not value or value == '' or value == "" then
        return 0
    end

    local t = tonumber(value)
    if t then
        return 0
    end

    return ZZBase64.decode(value)
end

--读取积分
for i=1,8 do
    local player = ac.player[i]
    if player:is_player() then

        --读取积分
        local jifen  = tonumber(ac.GetServerValue(player,'jifen'))
        -- print('服务器积分：',player,jifen)

        --保存服务端积分
        player.jifen = ZZBase64.encode(jifen)

    else
        player.jifen = 0

    end
end


ac.game:event '积分变化'(function(_,p,value)
    ac.jiami(p,'jifen',value)
end)

local function save_jifen()
    for i=1,10 do
        local p = ac.player[i]
        if p:is_player() then
            --只保存一次
            local value
          
            value = (ac.total_putong_jifen - (ac.old_total_putong_jifen or 0)) * (ac.g_game_degree or 1) / get_player_count() 
            -- (p.putong_jifen - (p.old_putong_jifen or 0)) * (p.hero:get '积分加成' + (ac.g_game_degree or 1) )
            value = value * (p.hero:get '积分加成' + 1)
            -- print('当前回合最终加的积分',value,'总积分',ac.total_putong_jifen,'难度倍数',ac.g_game_degree,'在线玩家数',get_player_count(),'积分加成',p.hero:get '积分加成')

            local total_value = (ac.total_putong_jifen* (ac.g_game_degree or 1)) / get_player_count() * (p.hero:get '积分加成' + 1)
            -- print('累计获得的积分',total_value)
            -- end 
            ac.old_total_putong_jifen = ac.total_putong_jifen
            --保存积分
            ac.jiami(p,'jifen',value)

            --修改排行榜的积分
            if p:is_self() then
                c_ui.ranking.ui.integral:set_text('本局累计获得积分：'..total_value)
            end

          
        end
    end
end    
ac.save_jifen = save_jifen
--保存积分方式： 1.无尽后，每回合开始保存。2.打死最终boss保存
ac.game:event '游戏-回合开始'(function(_,index,creep)
    if creep.name ~= '刷怪-无尽' then
        return
    end    
    ac.save_jifen()
end)





