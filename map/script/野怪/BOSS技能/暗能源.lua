local mt = ac.skill['暗能源']
mt.effect = [[Abilities\Weapons\AvengerMissile\AvengerMissile.mdl]]

function mt:boss_skill_shot()
    local hero = self.owner
    local skill = self
    local damage_data = skill:damage_data_cal()
    
    local time = 3
    local num = 20
    local list = {}
    local group = {}
    local speed = skill.area/time
    for i = 1,num do
        list[i] = hero:follow
        {
            start = hero:get_point(),
            source = hero,
            skill = skill,
            model = skill.effect,
            angle = 360/10*i,
            angle_speed = 120,
            distance_speed = speed,
            size = 2,
            high = 50,
        }
    end

    local timer
	local tm = 0
    timer = ac.loop(0.1*1000,function()
    	tm = tm + 1
    	local point = hero:get_point()
    	for _,u in ac.selector()
	    	: in_range( point, speed * tm * 0.1 )
	    	: is_enemy(hero)
	    	: ipairs()
    	do
	    	if not group[u] then
		    	if point * u:get_point() > speed * tm * 0.1 -120 then
			    	group[u] = true
			    	skill:damage
			    	{
			    		source = hero,
			    		target = u,
			    		damage = damage_data.damage,
			    		damage_type = damage_data.damage_type,
		    		}
		    		u:add_effect('chest',skill.effect):remove()
	    		end
    		end
    	end
    end)

    hero:wait(time*1000,function()
    	timer:remove()
		tm = 0
		group = {}
	    timer = ac.loop(0.1*1000,function()
	    	tm = tm + 1
    		local point = hero:get_point()
	    	for _,u in ac.selector()
		    	: in_range( point, skill.area - speed * tm * 0.1 + 50 )
		    	: is_enemy(hero)
		    	: ipairs()
	    	do
		    	if not group[u] then
			    	if point * u:get_point() > skill.area - speed * tm * 0.1 -100 then
				    	group[u] = true
				    	skill:damage
				    	{
				    		source = hero,
				    		target = u,
				    		damage = damage_data.damage,
				    		damage_type = damage_data.damage_type,
				    	}
		    			u:add_effect('chest',skill.effect):remove()
			    	end
		    	end
	    	end
	    end)
        for i = 1,num do
            list[i]:remove()
            list[i] = hero:follow
            {
                start = hero:get_point() - {360/10*i,skill.area},
                distance = skill.area,
                source = hero,
                skill = skill,
                model = skill.effect,
                angle = 360/10*i,
                angle_speed = 120,
                distance_speed = -skill.area/time,
                size = 2,
                high = 50,
            }
        end
        hero:wait(time*1000,function()
    		timer:remove()
            for i = 1,num do
                list[i]:remove()
            end
        end)
    end)
end

function mt:on_cast_start()
    self.eft = ac.warning_effect_ring
    {
        point = self.owner:get_point(),
        area = self.area,
        time = self.cast_channel_time,
    }
end

function mt:on_cast_shot()
    self:boss_skill_shot()
end

function mt:on_cast_stop()
    if self.eft then
        self.eft:remove()
    end
end

local mt = ac.buff['暗能源-发射']
mt.pulse = 0.03
function mt:on_add()
end