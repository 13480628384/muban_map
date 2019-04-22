local mt = ac.skill['生存会员']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
	--技能目标
	target_type = ac.skill.TARGET_TYPE_NONE,
	--介绍
	tip = [[]],
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNFlakCannons.blp]],
	--特效
	effect = [[]],
	--物品获取率
	fall_rate = 25,
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    hero:add('物品获取率',self.fall_rate)

    
    --开局得一个随机装备,之后每10波随机得到一个装备
    if self.trg then self.trg:remove() end

    local function give_rand_item()
        --给英雄随机添加物品
        local rand_list = ac.unit_reward['商店随机物品']
        local rand_name = ac.get_reward_name(rand_list)
        if not rand_name then 
            return
        end    

        local list = ac.quality_item[rand_name] 
        --添加 
        local name = list[math.random(#list)]
        --满时，掉在地上
        hero:add_item(name,true)
    end
    --第0波时先给一个随机物品
    if ac.creep['刷怪'].index == 0 then 
        give_rand_item()
    end    
    self.trg = ac.game:event '游戏-回合开始'(function(trg,index, creep) 
        if creep.name ~= '刷怪' then
            return
        end    
        --取余数,为0 得给物品
        local value = ac.creep['刷怪'].index % 10
        if value == 0 then 
            give_rand_item()
        end    
    end)    
    
end
function mt:on_remove()
    local hero = self.owner
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    
    hero:add('物品获取率',-self.fall_rate)
end
