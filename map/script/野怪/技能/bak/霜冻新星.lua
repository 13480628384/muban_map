local mt = ac.skill['霜冻新星']

--目标类型
mt.target_type = ac.skill.TARGET_TYPE_UNIT
--初始等级
mt.level = 1
--技能图标
mt.art = [[ReplaceableTextures\CommandButtons\BTNGlacier.blp]]
--技能说明
mt.title = '霜冻新星'
mt.tip = [[
       造成%damage_base%魔法伤害
]]

--伤害
mt.damage_base = 100

--冷却时间
mt.cool = 30 

--施法距离
mt.range = 500

function mt:on_add()

    local hero = self.owner 
 
    -- if not hero:is_type('野怪') then 
    --     return 
    -- end 
    
    --给野怪注册自动释放的ai

    self.trg = hero:event '造成伤害开始' (function (_,damage)
        local target = damage.target

        if damage:is_common_attack() == false then 
            return 
        end 

        if self:get_cd() == 0 then 

            hero:cast('霜冻新星',target)
        end 
        
    end)


end

function mt:on_cast_shot()
    local hero = self.owner 
    local target = self.target 
    local point = target:get_point()
    local effect = point:effect
    {
        model = [[Abilities\Spells\Undead\FrostNova\FrostNovaTarget.mdl]],
    }
    effect:remove()

    target:damage
    {
        source = hero,
        damage = self.damage_base, 
        skill = self,
        aoe = true,
    }

end 


function mt:on_remove()
    if self.trg then 

        self.trg:remove()
        self.trg = nil

    end 
end

