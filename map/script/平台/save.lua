

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


        --读取波数
        local value = player:Map_GetServerValue('boshu')
        if not value or value == '' or value == "" then
            player.boshu = 0
        else
            player.boshu = tonumber(value)
        end
        -- print('服务器波数：',player, player.boshu)

        --保存服务端积分
        player.jifen = ZZBase64.encode(jifen)

        --修复积分为负数的，并奖励10000积分
        if jifen < 0 then 
            local value = -jifen + 10000
            print(jifen,value)
            ac.jiami(player,'jifen',value)
            ac.player.self:sendMsg('【系统消息】 已修复积分为0，并发放 积分10000 作为补偿',tonumber(ac.GetServerValue(player,'jifen')))
        end    

    else
        player.jifen = 0
        player.boshu = 0
    end
end


ac.game:event '积分变化'(function(_,p,value)
    ac.jiami(p,'jifen',value)
end)

local function save_jifen()
    --只保存一次
    local value
    value = (ac.total_putong_jifen - (ac.old_total_putong_jifen or 0)) * (ac.g_game_degree or 1) / get_player_count() 
    ac.old_total_putong_jifen = ac.total_putong_jifen

    for i=1,10 do
        local p = ac.player[i]
        if p:is_player() then
            -- (p.putong_jifen - (p.old_putong_jifen or 0)) * (p.hero:get '积分加成' + (ac.g_game_degree or 1) )
            local p_value = value * (p.hero:get '积分加成' + 1)
            -- print('当前回合最终加的积分',value,'总积分',ac.total_putong_jifen,'难度倍数',ac.g_game_degree,'在线玩家数',get_player_count(),'积分加成',p.hero:get '积分加成')

            local total_value = (ac.total_putong_jifen* (ac.g_game_degree or 1)) / get_player_count() * (p.hero:get '积分加成' + 1)
            -- print('累计获得的积分',total_value)
            -- end 
            -- print('本回合保存积分：',p,p_value)
            --保存积分
            ac.jiami(p,'jifen',p_value)

            --修改排行榜的积分
            if p:is_self() then
                c_ui.ranking.ui.integral:set_text('本局累计获得积分：'..total_value)
            end

          
        end
    end
end    
ac.save_jifen = save_jifen


local rank_art = {'黑铁','黄铜','白银','黄金','铂金','钻石','大师','王者'}
--设置房间KEY
local function set_fangjian_xm(p,count)
    local value = 1
    --段位为1-7 青铜 白银 黄金 白金 钻石 大师 王者
    if count <= 10 then
        value = 1
    elseif count <=20 then
        value = 2
    elseif count <=30 then
        value = 3
    elseif count <=40 then
        value = 4
    elseif count <=50 then
        value = 5
    elseif count <=60 then
        value = 6
    elseif count <=70 then
        value = 7
    elseif count >= 100 then
        value = 8
    end

    if p:GetServerValueErrorCode() then
        p:Map_Stat_SetStat('dw',rank_art[value])
    end
    --实时更新游戏内的段位数据
    p.rank = value
end

--保存积分方式： 1.无尽后，每回合开始保存。2.打死最终boss保存
ac.game:event '游戏-回合开始'(function(_,index,creep)
    if creep.name ~= '刷怪-无尽' then
        return
    end    
    ac.save_jifen()
    
    --保存波数
    for i=1,10 do
        local p = ac.player[i]
        if p:is_player() then
            if creep.index > p.boshu then
                if ac.g_game_degree == 2 then 
                    if creep.index <= 40 then 
                        p:Map_SaveServerValue('boshu',creep.index)
                        set_fangjian_xm(p,creep.index)
                    end    
                else
                    p:Map_SaveServerValue('boshu',creep.index)
                    set_fangjian_xm(p,creep.index)
                end    
            end    
        end 
    end      
end)





