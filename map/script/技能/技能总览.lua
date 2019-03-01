
--[[

    在F9打开的任务栏中 显示所有技能图标 名字 跟 说明

]]
--技能列表
ac.skill_list2 = {
    '重击','暴击','粉碎','闪电手','硬化皮肤','闪避','望远镜','弹射','智者','长者','专心','财富','缠绕','风暴锤子','击地',
    '践踏','穿刺','时间静止','妖刀','静止陷阱','荆棘','精准射击','才华','信仰','耐力','战鼓','吸血鬼','赢家','财源滚滚',
    '冰冷核心','魔王降临','暴风雪','阳光枪','火焰雨','巨浪','飞焰','炎爆术','光子灵枪','闪电链','死亡之指','死亡脉冲','痛苦尖叫',
    '吸精','摔破罐子','刀刃旋风','黑暗契约','死亡飞镖','闪烁','狂猛','属性转换','献祭','群体治疗','圣光','治疗守卫','冰甲','心灵之火',
    '闪电手','愤怒','爱屋及乌','盗取','自然之力','水元素','影子','狼','地狱火','凤凰','F4战斗机','战鹰','硬币机器','张全蛋'
}
local function initialize()
    local unit = ac.player(16):create_dummy('e001',ac.point(0,0),0)

    local list = ac.skill_list2

    table.sort(list,function (a,b) return a < b end)
    
    for index,name in ipairs(list) do 
        local skill = unit:add_skill(name,'隐藏')
        local title = name
        local tip = skill:get_simple_tip(nil,1)
        local art = skill:get_art()

        local quest = CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED,title,tip,art)
        skill:remove()
    end 
    unit:remove()
end 



initialize()