 require '野怪.BOSS光环.BOSS-专注光环'
 require '野怪.BOSS光环.BOSS-吸血光环'
 require '野怪.BOSS光环.BOSS-命令光环'
 require '野怪.BOSS光环.BOSS-耐久光环'
 require '野怪.BOSS光环.BOSS-恢复光环'

local list = {
    'buff-专注光环',
    'buff-吸血光环',
    'buff-命令光环',
    'buff-耐久光环',
    'buff-恢复光环'
}

local mt = ac.skill(list)


function mt:on_add()
    local hero = self.owner 
    local player = hero:get_owner()
    local name = self:get_name()
    self.eff = hero:add_effect('origin',self.effect)

    self.timer = ac.loop(1000,function ()
        for _,unit in ac.selector()
            : in_rect()
            : is_ally(hero)
            : ipairs()
        do 
            unit:add_buff(name)
            {
                value = self.value,
                time = 1,
                art = self.art,
                tip = self.data.tip,
                title = name,
            }
        end 
    end)

end


function mt:on_remove()
    if self.timer then 
        self.timer:remove()
        self.timer = nil
    end 
    if self.eff then 
        self.eff:remove()
        self.eff = nil
    end 
end 

