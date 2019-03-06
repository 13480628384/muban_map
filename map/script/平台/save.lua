local Base64 = require 'ac.Base64'
local store = require 'ui.client.store'

ac.jm_sjs = math.random(1,4399)

function ac.jiami(p,key,value)
    local v = ZZBase64.decode(p[key])
    v = (v / ac.jm_sjs + value)
    p[key] = ZZBase64.encode(v *ac.jm_sjs )

    if p:GetServerValueErrorCode() then
        p:Map_Stat_SetStat('fjjf',tostring(v))
    end
    ac.SaveServerValue(p,key,v)
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

--存档
function ac.SaveServerValue(p,KEY,value)
    value = tostring(value)
    local s = ZZBase64.encode(value)
    p:Map_SaveServerValue(KEY,s)
    --保存一下，只清零一次
    p:Map_SaveServerValue('is',1)
end

--读取积分
for i=1,8 do
    local player = ac.player[i]
    if player:is_player() then
        --读取积分
        local jifen  = tonumber(ac.GetServerValue(player,'jifen'))

        --设置客户端的积分
        if player:is_self() then
            c_ui.store.set_jifen(jifen)
        end

        --保存服务端积分
        player.jifen = ZZBase64.encode(jifen * ac.jm_sjs)
        
        --读取波数
        local value = player:Map_GetServerValue('boshu')
        if not value or value == '' or value == "" then
            player.boshu = 0
        else
            player.boshu = tonumber(value)
        end

        --读取王者点数
        local dianshu = player:Map_GetServerValue('ds')
        if not dianshu or dianshu == '' or dianshu == "" then
            player.dianshu = 0
        else
            dianshu = tonumber(dianshu)
            if dianshu > 1500 then
                player.dianshu = 0
            else
                player.dianshu = tonumber(dianshu)
            end
        end
    else
        player.boshu = 0
        player.jifen = 0
        player.dianshu = 0
    end
end


local rank_art = {'黑铁','黄铜','白银','黄金','铂金','钻石','大师','王者'}
--设置房间KEY
local function set_fangjian_xm(p,count)
    local value = 1
    --段位为1-7 青铜 白银 黄金 白金 钻石 大师 王者
    if count <= 20 then
        value = 1
    elseif count <=40 then
        value = 2
    elseif count <=70 then
        value = 3
    elseif count <=100 then
        value = 4
    elseif count <=150 then
        value = 5
    elseif count <=170 then
        value = 6
    elseif count <=200 then
        value = 7
    elseif count >= 201 then
        value = 8
    end

    if p:GetServerValueErrorCode() then
        p:Map_Stat_SetStat('fjdw',rank_art[value])
    end
end


ac.game:event '积分变化'(function(_,p,value)
    ac.jiami(p,'jifen',value)
end)


ac.game:event '游戏-回合开始'(function(_,army)
    if ac.Gamemode == '新手' then
        return
    end

    if army.now_count - 11 > 0 then
        for i=1,8 do
            local p = ac.player[i]
            if p:is_player() then
                local value = 1 + p.hero:get '积分加成'
                --保存积分
                ac.jiami(p,'jifen',value)

                --修改排行榜的积分
                if p:is_self() then
                    c_ui.ranking.ui.integral:set_text('本局累计获得积分：'..(army.now_count - 11)*value)
                end

                if ac.nandu_id <= 2 then
                    --保存波数
                    if army.now_count - 11 > p.boshu then
                        p:Map_SaveServerValue('boshu',army.now_count - 11)
                        set_fangjian_xm(p,army.now_count - 11)
                    end
                else
                    --难3保存点数 段位小于王者的不保存
                    if p.rank == 8 then
                        if army.now_count - 11 > p.dianshu then
                            p:Map_SaveServerValue('ds',army.now_count - 11)
                            p:Map_Stat_SetStat('fjwz',army.now_count - 11)
                        end
                    end
                end
            end
        end
    end
end)


--保存锋芒点
ac.game:event '游戏-回合结束'(function(_,army)
    if ac.nandu_id <= 2 then
        return
    end

    if army.now_count <=10 then
        return
    end

    local count = army.now_count - 10
    --每5波加1精魄
    local a,b = math.modf(count / 5)
    if b == 0 then
        for i=1,8 do
            local p = ac.player[i]
            if p:is_player() then
                p.cd_jp = p.cd_jp + 1
                p:Map_SaveServerValue('jp',p.cd_jp)
                p:Map_Stat_SetStat('fjjp',p.cd_jp)
            end
        end
    end
end)


--元旦
for i=1,8 do
    local p = ac.player[i]
    if p:is_player() then
        --先判断是否存在皮肤，如果存在则添加道具
        local is = p:Map_GetServerValue('ydpf')
        if is and is == '1' then
            p.hero:add_item('小黑零号',1)
        end
    end
end
