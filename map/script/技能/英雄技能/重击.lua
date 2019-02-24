local mt = ac.skill['重击']

mt{
	--必填
	is_skill = true,

	--是否被动
	passive = true,
	
	--初始等级
	level = 1,
	
	tip = [[
		|cff00ccff被动|r:
		攻击时 %chance% %触发， 造成 攻击力*1.5 的物理伤害 (%damage%) ，并击晕敌人 %time% 秒，近战有效
	]],
	
	--技能图标
	art = [[ReplaceableTextures\PassiveButtons\PASBTNBash.blp]],

	--概率
	chance = 10,

	--伤害
	damage = function(self,hero)
		return hero:get('攻击')*1.5
	end,	

}


function mt:on_add()
	local skill = self
	local hero = self.owner 
	self.trg = hero:event '造成伤害效果' (function(trg, damage)
		--普攻触发 and 近战
		if damage:is_common_attack() and damage.source:isMelee()  then
            --几率触发
			if math.random(1,100) > self.chance then
				return
			end
	 	   damage.target:add_buff('晕眩')
			{
				source = hero,
				skill = skill,
				time =  skill.time,
				damage = skill.damage
			}
		end
	end)

end	

function mt:on_remove()

    local hero = self.owner 
	
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end    

end
