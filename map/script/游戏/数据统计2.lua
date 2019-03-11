local player = require 'ac.player'
local hero = require 'types.hero'
local ranking = require 'ui.client.ranking'


--已刷新的BOSS数量
ac.boss_count = 0

--初始化一下玩家的变量名
for i=1,10 do
    local player = ac.player[i]
    --杀敌数
    player.kill_count = 0
    --死亡数
    player.death = 0
    --金币数
    player.gold_count = 0
    --承受伤害
    player.take_damage_count = 0
    --造成伤害
    player.damage_count = 0
    --参团率
    player.ctl = 0
    --kda
    player.kda = 0

    --段位为1-7 青铜 白银 黄金 白金 钻石 大师 王者
    if player.boshu <= 20 then
        player.rank = 1
    elseif player.boshu <=40 then
        player.rank = 2
    elseif player.boshu <=70 then
        player.rank = 3
    elseif player.boshu <=100 then
        player.rank = 4
    elseif player.boshu <=150 then
        player.rank = 5
    elseif player.boshu <=180 then
        player.rank = 6
    elseif player.boshu <= 200 then
        player.rank = 7
    elseif player.boshu >= 201 then
        player.rank = 8
    end

end


--数值转换
local function numerical(value)
    if value < 10000 then
        return (' %.0f'):format(value)
    elseif value < 100000000 then
        return (' %.1f'):format(value/10000)..'万'
    else
        return (' %.1f'):format(value/100000000)..'亿'
    end

end

--段位贴图
local rank_art = {
    'image\\排行榜\\qt.tga',
    'image\\排行榜\\by.tga',
    'image\\排行榜\\hj.tga',
    'image\\排行榜\\bj.tga',
    'image\\排行榜\\zs.tga',
    'image\\排行榜\\ds.tga',
    'image\\排行榜\\wz.tga',
}

local rank_art = {'黑铁','英勇黄铜','不屈白银','荣耀黄金','华贵铂金','璀璨钻石','超凡大师','最强王者'}
--计算KDA
local function get_kda()
    --杀敌数
    local kill_count = 0
    --金币
    local gold_count = 0
    --承受伤害
    local take_damage_count = 0
    --造成伤害
    local damage_count = 0
    --死亡数
    local death = 0

    --计算出总值
    for i=1,8 do
        local p = ac.player[i]
        kill_count = kill_count + p.kill_count
        gold_count = gold_count + p.gold_count
        take_damage_count = take_damage_count + p.take_damage_count
        damage_count = damage_count + p.damage_count
        death = death + p.death
    end

    local t = {}
    for i,p in ipairs(ac.player_list) do
        local a = 0
        local b = 0
        local c = 0
        local d = 0
        local e = 0
        local f = 0
        if kill_count > 0 then
            a = p.kill_count / kill_count * 20
        end

        if gold_count > 0 then
            b = p.gold_count / gold_count * 10
        end

        if take_damage_count > 0 then
            c = p.take_damage_count / take_damage_count * 20
        end

        if damage_count > 0 then
            d = p.damage_count / damage_count * 30
        end

        if ac.boss_count > 0 then
            e = p.ctl / ac.boss_count * 10
        end

        if death > 0 then
            f = p.death / death * 10
        end

        p.kda = a+b+c+d+e-f
        table.insert(t,{id = p:get(),kda = p.kda})
    end

    --排序
    table.sort(t,function(a,b) return a.kda>b.kda end)

    for i = 1, #t do
        local id = t[i].id
        local p = ac.player[id]
        --玩家名
        local p_name = p:get_name()..' '

        ranking.ui.player[i]:set_text(p_name)
        --段位
        ranking.ui.rank[i]:set_text(rank_art[p.rank])
        --ranking.ui.rank[i]:set_normal_image(rank_art[p.rank])
        --杀敌数
        ranking.ui.kill_count[i]:set_text(p.kill_count)
        --死亡数
        ranking.ui.death_count[i]:set_text(p.death)
        --获得金币
        ranking.ui.gold_count[i]:set_text(numerical(p.gold_count))
        --累计伤害
        ranking.ui.damage_count[i]:set_text(numerical(p.damage_count))
        --受到伤害
        ranking.ui.take_damage[i]:set_text(numerical(p.take_damage_count))
        --参团率
        ranking.ui.ctl[i]:set_text(numerical(p.ctl))
        --kda
        ranking.ui.kda[i]:set_text(numerical(p.kda))
        if p:is_self() then
            local y = (i-1) * 40 + 37
            ranking.ui.lk:set_position(20,y)
            ranking.ui.lk:show()
        end

    end
end


--注册事件
for _,hero in ipairs(ac.player_hero_group) do
    local p = hero.owner
    hero:event '单位-死亡'(function()
        p.death = p.death + 1
    end)

    hero:event '造成伤害结束'(function(_,self)
        p.damage_count = p.damage_count + self.current_damage
    end)

    hero:event '受到伤害结束'(function(_,self)
        p.take_damage_count = p.take_damage_count + self.damage
        if hero:get '生命' / hero:get '生命上限' < 0.12 then
            local fl = hero:get_owner():cinematic_filter
            {   
                file = 'xueliangguodi.blp',
                start = {100, 100, 100, 100},
                finish = {100, 100, 100, 0},
                time = 5,
            }
        end
    end)

    hero.owner:event '玩家-即将获得金钱'(function(_,data)
        local p = data.player
        local gold = data.gold
        p.gold_count = p.gold_count + gold
    end)

end