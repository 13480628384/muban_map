--每回合开始，60秒后，中央boss释放死亡之环
--同时存活人数为0 ，游戏失败 （标准模式）
--
ac.game:event '游戏-回合开始'(function(trg,index, creep) 
    if creep.name ~= '刷怪' then
        return
    end  
    -- 回合开始，倒计时释放死亡之环
    local time = 60

    if not creep.boss then 
        local unit = ac.player.com[2]:create_unit('最终boss',ac.map['刷怪中心点'],270)
        unit:set_size(1)
        unit:add_restriction '定身'
        unit:add_restriction '缴械'
        unit:add_restriction '无敌'
        -- unit:setColor(100,100,100)
        -- unit:setColor(68,68,68)
        -- unit:set_animation 'Stand Ready'
        unit:add_skill('死亡之环','英雄')

        creep.boss = unit
    end 
    local c_boss_buff = creep.boss:find_buff '时停' 

    if c_boss_buff then 
        c_boss_buff:remove()
    end   

    --释放完后，等待2秒继续僵硬
    creep.boss:add_buff '时停'
    {
        time = time,
        skill = '游戏模块',
        source = unit,
        show = true
    }
    if creep.boss.waiter1 then 
        creep.boss.waiter1:remove()
    end
     
    if creep.boss.waiter2 then 
        creep.boss.waiter2:remove()
    end   
    creep.boss.waiter1 = creep.boss:wait(time*1000,function()

        creep.boss:force_cast('死亡之环')
        --释放完后，等待2秒继续僵硬
        creep.boss.waiter2 = creep.boss:wait(2*1000,function()
            creep.boss:add_buff '时停'
            {
                time = 99999,
                skill = '游戏模块',
                source = unit,
            }
        end);    
    end);
   
end)
--进入最终boss阶段，boss苏醒，打败boss进入无尽
ac.game:event '游戏-最终boss' (function(trg,index, creep) 
    if creep.name ~= '刷怪' then
        return
    end  
    --boss 苏醒动画
    local c_boss_buff = creep.boss:find_buff '时停' 
    if c_boss_buff then 
        c_boss_buff:remove()
    end   
    creep.boss:remove_restriction '无敌' 
    creep.boss:remove_restriction '定身'
    creep.boss:remove_restriction '缴械'
    --设置搜敌路径
    creep.boss:set_search_range(99999)
    --注册事件
    creep.boss:event '单位-死亡'(function(_,unit,killer) 
        --难1， 游戏胜利  
        --难2、3 ， 20秒后进入无尽 
        if ac.g_game_degree ==1 then 
            ac.game:event_notify('游戏-结束',creep.index,true)
        else   
            ac.creep['刷怪-无尽']:start()
            ac.game:event_dispatch('游戏-无尽开始',creep.index,creep) 
        end    
    end)  
    

end);    


