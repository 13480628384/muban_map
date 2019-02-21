local mt = ac.skill['隐蔽者']

mt.title = "隐蔽者"
mt.tip = [[
    被动1：提升自己的闪避率90%
    被动2：降低自己的三维40%
]]

--影响三维值 (怪物为：生命上限，护甲，攻击力)
mt.value = 40

--闪避
mt.dodge = 90


function mt:on_add()

    local hero = self.owner 
    
    -- 降低三维(生命上限，护甲，攻击)
    hero:add('生命上限%', -self.value)
    hero:add('护甲%', -self.value)
    hero:add('攻击%', -self.value)

    -- 降低自己攻击速度、移动速度
    hero:add('闪避', self.dodge)

end


function mt:on_remove()

    local hero = self.owner 
    -- 提升三维(生命上限，护甲，攻击)
    hero:add('生命上限%', self.value)
    hero:add('护甲%', self.value)
    hero:add('攻击%', self.value)

    -- 降低自己攻击速度、移动速度
    hero:add('闪避', -self.dodge)


end

