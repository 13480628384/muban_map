local mt = ac.skill['交叉闪电']
mt{
    --等级
    level = 1,
    --是被动
    passive = true,
	--技能类型
	skill_type = "被动",

    --原始伤害
    damage = function(self,hero)
		if self and self.owner then 
			return self.owner:get('敏捷')*2
		end	
	end,

    --投射物数量
    count = function(self,hero)
        return hero:get '额外投射物数量' + 2
    end,
    --图标
    art = [[weisuoshandianjian.tga]],

    --释放几率
    chance = function (self,hero)
        return 100 + hero:get '天赋触发几率'
    end,

    --交叉闪电数量
    lig_count = 3,

    --二段伤害
    ejection_damage = 45,


    --投射物模型
    model = [[FirecrackerArrow.mdx]],
    title = '交叉闪电',
    tip = [[标签：|cff0c97d1投射物|r
攻击时有 %chance% % 几率释放 %count% 个金钱镖飞向敌人造成伤害，命中时会对周围 %lig_count% 个敌人释放交叉闪电，造成 %ejection_damage% % 的伤害
伤害计算：|cffd10c44力量 * 2|r(伤害: %damage% )
伤害类型：物理伤害]],
}

--计算高度
local function get_hith(u)
    local weapon_launch = u.weapon and u.weapon['弹道出手']
    local launch_z = weapon_launch and weapon_launch[3] or u:get_slk('launchZ', 0)
    launch_z = u:get_high() + launch_z
    return launch_z
end

--交叉闪电
local function jiaocha_sd(skill,target,damage)
    local hero = skill.owner

    for _, u in ac.selector():in_range(target,800):is_enemy(hero):random_int(skill.lig_count) do
        local ln = ac.lightning('LN01', hero, u,get_hith(hero),get_hith(u))
        ln:fade(-5)
        u:add_effect('origin',[[AZ_SSCrow_R2.mdx]]):remove()
        u:damage{
            source = hero,
            skill = skill,
            damage = damage * (skill.ejection_damage/100),
        }
    end

end


function mt:on_add()
    local hero = self.owner
    -- hero:add('理财提升',20)
    --记录默认攻击方式
    if not hero.oldfunc then
        hero.oldfunc = hero.range_attack_start
    end

    --新的攻击方式
    local function range_attack_start(hero,damage)
        if damage.skill and damage.skill.name == self.name then
            return
        end
        --计算伤害
        local max_damage = self.current_damage
        local target = damage.target
        
        --投射物数量
        local count = hero:get '额外投射物数量' + 1
        local group = ac.selector():in_range(hero,hero:get '攻击距离'):is_enemy(hero):is_not(target):get()
        if group and #group > 0 then
            while #group > count do
                table.remove(group,#group)
            end
        end
        table.insert(group,target)

        for i,u in ipairs(group) do
            local mvr = ac.mover.target
            {
                source = hero,
                start = hero:get_launch_point(),
                skill = self,
                target = u,
                speed = 1500,
                model = self.model,
                size = 1.3,
            }
            if mvr then
                function mvr:on_finish()
                --交叉闪电
                jiaocha_sd(self.skill,u,max_damage)
                    u:damage
                    {
                        source = hero,
                        damage = max_damage,
                        skill = self.skill,
                    }
                end   
            end
        end

      --还原默认攻击方式
      hero.range_attack_start = hero.oldfunc
    end    

	self.trg = hero:event '造成伤害效果' (function(_,damage)
		if not damage:is_common_attack()  then 
			return 
		end 
        --触发时修改攻击方式
        if math.random(100) <= self.chance then
            
            self = self:create_cast()
            --当前伤害要在回调前初始化
            self.current_damage = self.damage
            hero:event_notify('触发天赋技能', self)
            --修改攻击方式
            --hero.range_attack_start = range_attack_start
            range_attack_start(hero,damage)
        end

        return false
    end)

end



function mt:on_remove()
    local hero = self.owner
    hero.range_attack_start = hero.oldfunc
    self.trg:remove()
    -- hero:add('理财提升',-20)
end