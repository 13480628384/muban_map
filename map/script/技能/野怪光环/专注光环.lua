--物品名称
local mt = ac.skill['专注光环']

mt.art = [[ReplaceableTextures\PassiveButtons\PASBTNDevotion.blp]]
mt.title = "专注光环"
mt.tip = [[
增加%value%点护甲
]]

--光环附着时间
-- mt.time = 1

--光环扫描周期
-- mt.pulse = 0.5

--影响范围
mt.area = 99999
--影响值
mt.value = 120


function mt:on_add()
	local hero = self.owner
	if hero:is_illusion() then
		return
	end
	local area = self.area
	-- local pulse = self.pulse * 1000
    -- local time = self.time
    -- print('打印光环持有者的队伍',hero:get_team())
	self.buff = hero:add_buff '专注光环'
	{
		source = hero,
		skill = self,
		selector = ac.selector()
			: in_range(hero, self.area)
			: is_ally(hero)
			-- : is_not(hero) --自己不加，好像没生效
			-- : of_hero()
			,
        -- buff的数据，会在所有自己的子buff里共享这个数据表
        data = {
            value = self.value
        },
	}
end

function mt:on_remove()
	if self.buff then
		self.buff:remove()
	end
end



local mt = ac.aura_buff['专注光环']
-- 魔兽中两个不同的专注光环会相互覆盖，但光环模版默认是不同来源的光环不会相互覆盖，所以要将这个buff改为全局buff。
mt.cover_global = 1

mt.cover_type = 1
mt.cover_max = 1

mt.effect = [[Abilities\Spells\Human\DevotionAura\DevotionAura.mdl]]
mt.target_effect = [[Abilities\Spells\Other\GeneralAuraTarget\GeneralAuraTarget.mdl]]


function mt:on_add()
	-- 如果这个buff在所有者身上，则加上一个比较特别的特效
	if self.source == self.target then
        -- self.source_eff = self.target:add_effect('origin', self.effect)
    else
        -- 受到影响的单位都会有一个简单的特效
        self.target_eff = self.target:add_effect('origin', self.target_effect)
	end
    -- print('打印受光环英雄的单位',self.target:get_name())
	-- 增加护甲
    self.target:add('护甲', self.data.value)
    
end
function mt:on_remove()
	if self.source_eff then self.source_eff:remove() end
	if self.target_eff then self.target_eff:remove() end
    self.target:add('护甲', -self.data.value)
    
end
