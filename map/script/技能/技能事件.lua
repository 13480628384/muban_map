--技能事件
ac.game:event '技能-施法完成' (function(trg, _, skill)
    local hero = skill.owner
    if not hero then 
        return 
    end
    --攻击自己脚下
    -- print('111')
    hero:issue_order('attack',hero:get_point())
end)