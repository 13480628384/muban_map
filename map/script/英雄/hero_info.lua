--[[ 
应用场景： 英萌里面每个英雄 技能右上角显示 此英雄的属性值。（攻击力、穿透率、生命等 ）

特别注意：tip 里面的 %life% 调取局部life 函数，获得返回值。

]]

local damage = require 'types.damage'

local mt = ac.skill['英雄属性面板']
{
	level = 1,

	max_level = 1,

	never_copy = true,

	passive = true,
	
	ability_id = 'B889',

	tip = [[
生命:    %life% / %max_life% %life_recover% 
%resource_type%:    %mana% / %max_mana% %mana_recover% 
%shield%

攻击:    %attack% （已加成 %attack_per% %）
攻击间隔:    %attack_gip% 
攻速:    %attack_speed% (每秒攻击%attack_rate%次)
溅射:    %splash% %
破甲:    %pene% (%pene_rate% %)
吸血:    %life_steal%
冷却:    %cool_speed% %
防御:    %defence% (减免%defence_rate% %的伤害)
受到伤害:    %damaged_rate% %

物爆几率: %physical_rate% %  物爆伤害:  %physical_damage% %
法爆几率: %magic_rate% %  法爆伤害:  %magic_damage% %
会心几率: %heart_rate% %  会心伤害:  %heart_damage% %

召 唤 物加成： %dummy%   召唤物属性加成： %dummy_attr% %
法术攻击加成： %magic_attack% % 

主动释放的增益效果： %moregood% % 

金币加成：   %moregold% %
经验加成：   %moreexp% %
物品获取率： %item_rate% %

]],
}

function mt:attack()
	return ('|cffF9C801%.f|r'):format(self.owner:get '攻击')
end
function mt:attack_per()
	return ('|cffF9C801%.2f|r'):format(self.owner:get '攻击%')
end


function mt:physical_rate()
	return ('|cffF9C801%.2f|r'):format(self.owner:get '物爆几率')
end

function mt:physical_damage()
	return ('|cffF9C801%.f|r'):format(self.owner:get '物爆伤害'+100)
end

function mt:magic_rate()
	return ('|cffF9C801%.2f|r'):format(self.owner:get '法爆几率')
end
function mt:magic_damage()
	return ('|cffF9C801%.f|r'):format(self.owner:get '法爆伤害'+100)
end

function mt:heart_rate()
	return ('|cffF9C801%.2f|r'):format(self.owner:get '会心几率')
end
function mt:heart_damage()
	return ('|cffF9C801%.f|r'):format(self.owner:get '会心伤害'+100)
end

function mt:dummy()
	return ('|cffF9C801%.f|r'):format(self.owner:get '召唤物')
end
function mt:dummy_attr()
	return ('|cffF9C801%.f|r'):format(self.owner:get '召唤物属性')
end
function mt:magic_attack()
	return ('|cffF9C801%.f|r'):format(self.owner:get '法术攻击')
end


function mt:moregood()
	return ('|cffF9C801%.f|r'):format(self.owner:get '主动释放的增益效果')
end


function mt:moregold()
	return ('|cffF9C801%.f|r'):format(self.owner:get '金币加成')
end
function mt:moreexp()
	return ('|cffF9C801%.f|r'):format(self.owner:get '经验加成')
end
function mt:item_rate()
	return ('|cffF9C801%.f|r'):format(self.owner:get '物品获取率')
end

local life_color = 'ff00dd11'

local function get_resource_color(hero)
	return ac.resource[hero.resource_type].color
end

function mt:on_add()
	local hero = ac.player.self.hero
	if hero then
		self.art = hero:get_slk 'Art'
		self:fresh_art()
		if self.owner:get_owner():is_self() then
			local name = self.owner:get_owner():getColorWord() .. hero:get_name() .. '|r'
			self.title = name
		end
	end
end

function mt:attack_gip()
	return ('|cffF9C801%.2f|r'):format(self.owner:get '攻击间隔')
end


function mt:life()
	return ('|c%s%.2f|r'):format(life_color, self.owner:get '生命')
end

function mt:max_life()
	return ('|c%s%.2f|r'):format(life_color, self.owner:get '生命上限')
end

function mt:life_recover()
	local recover = self.owner:get '生命恢复'
	local str = ('%.2f'):format(recover)
	if recover >= 0 then
		str = '+' .. str
	end
	if not self.owner.active then
		str = '|cff7f7f7f(' .. str .. ')|r'
	else
		str = '|cffffffff(|r|c' .. life_color .. str .. '|r|cffffffff)|r'
	end
	return str
end

function mt:life_recover_idle()
	local recover, recover_idle = self.owner:get '生命恢复', self.owner:get '生命脱战恢复'
	local str = ('%.2f'):format(recover + recover_idle)
	if recover >= 0 then
		str = '+' .. str
	end
	if self.owner.active then
		str = '|cff7f7f7f(' .. str .. ')|r'
	else
		str = '|cffffffff(|r|c' .. life_color .. str .. '|r|cffffffff)|r'
	end
	return str
end

function mt:mana()
	return ('|cff%s%.2f|r'):format(get_resource_color(self.owner), self.owner:get '魔法')
end

function mt:max_mana()
	return ('|cff%s%.2f|r'):format(get_resource_color(self.owner), self.owner:get '魔法上限')
end

function mt:mana_recover()
	local recover = self.owner:get '魔法恢复'
	local str = ('%.2f'):format(recover)
	if recover >= 0 then
		str = '+' .. str
	end
	if not self.owner.active then
		str = '|cff7f7f7f(' .. str .. ')|r'
	else
		str = '|cffffffff(|r|cff' .. get_resource_color(self.owner) .. str .. '|r|cffffffff)|r'
	end
	return str
end

function mt:mana_recover_idle()
	local recover, recover_idle = self.owner:get '魔法恢复', self.owner:get '魔法脱战恢复'
	local str = ('%.2f'):format(recover + recover_idle)
	if recover + recover_idle >= 0 then
		str = '+' .. str
	end
	if self.owner.active then
		str = '|cff7f7f7f(' .. str .. ')|r'
	else
		str = '|cffffffff(|r|cff' .. get_resource_color(self.owner) .. str .. '|r|cffffffff)|r'
	end
	return str
end

function mt:attack_speed()
	return ('|cffF9C801%.2f|r'):format(self.owner:get '攻击速度')
end

function mt:attack_rate()
	local attack_cool = self.owner:get '攻击间隔'
	local attack_speed = self.owner:get '攻击速度'
	if attack_speed >= 0 then
		attack_cool = attack_cool / (1 + attack_speed / 100)
	else
		attack_cool = attack_cool * (1 - attack_speed / 100)
	end
	return ('|cffF9C801%.2f|r'):format(1 / attack_cool)
end

function mt:crit_chance()
	return self.owner:get '暴击'
end

function mt:crit_damage()
	return self.owner:get '暴击伤害'
end

function mt:splash()
	return self.owner:get '溅射'
end

function mt:pene()
	return ('|cffF9C801%.2f|r'):format(self.owner:get '破甲')
end

function mt:pene_rate()
	local rate = self.owner:get '穿透'
	return rate
end

function mt:life_steal()
	return self.owner:get '吸血'
end

function mt:cool_speed()
	return ('|cffF9C801%.2f|r'):format(self.owner:getSkillCool(100))
end

function mt:cost_save()
	return ('|cffF9C801%.2f|r'):format(self.owner:get '减耗')
end

function mt:defence()
	return self.owner:get '护甲'
end

function mt:defence_rate()
	local def = self.owner:get '护甲'
	local rate = 0
	if def > 0 then
		rate = def * damage.DEF_SUB * 100 / (1 + def * damage.DEF_SUB)
	else
		rate = - def * damage.DEF_ADD
	end
	return ('|cffF9C801%.2f|r'):format(rate)
end

function mt:block_chance()
	return self.owner:get '格挡'
end

function mt:block_rate()
	local block_rate = self.owner:get '格挡伤害'
	return block_rate
end

function mt:resource_type()
	return '|r' .. self.owner.resource_type .. '|cffffffff'
end

function mt:damage_rate()
	return self.owner:getDamageRate()
end

function mt:damaged_rate()
	return self.owner:getDamagedRate()
end

function mt:shield()
    local v = self.owner:get '护盾'
    if v > 0 then
        return '|r护盾:    |cff77bbff' .. v .. '|r|n'
    end
    return ''
end
