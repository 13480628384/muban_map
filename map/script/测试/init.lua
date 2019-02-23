

require '测试.全图'



ac.game:event '单位-死亡'(function(self,unit,killer)
    ac.timer(0.1*1000,1,function()
        ac.item.create_item('新手剑',unit:get_point())
    
    end)
end)

-- local unit = ac.player(1):create_unit('强盗',ac.point(1000,1000))
-- unit:add('生命上限',20000)


-- local u = ac.player(2):createHero('小黑',ac.point(1100,1100))
-- local p = ac.player(2)
-- p.hero = u
-- print(u.unit_type)
-- u:add('生命上限',20000)

