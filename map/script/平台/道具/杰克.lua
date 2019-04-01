local japi = require("jass.japi")
--物品名称 商店物品
local mt = ac.skill['杰克']
mt{
--等级
level = 1,

--图标
art = [[icon\jieke.blp]],

--说明
tip = [[
|cff00ffff 
有皮肤特效
天赋技能 剑刃风暴 强化
物品获取率+10%；
|r
|cffff0000兑换后立即激活，可在宠物切换翅膀|r   
]],

--物品类型
item_type = '神符',

--目标类型
target_type = ac.skill.TARGET_TYPE_NONE,

--冷却
cool = 0,

--购买价格
jifen = 100000,
auto_fresh_tip = true,
--物品技能
is_skill = true,
--物品获取率
item_mul = 10,

--特效翅膀
effect = [[HeroCOCOBlack.mdx]],

}

function mt:on_add()
    local skill = self
    local hero = self.owner
    local player = hero:get_owner()
    hero = player.hero
    if not hero then 
        hero = self.owner 
    end
    self.old_model = hero:get_slk 'file'
	if not getextension(self.old_model) then 
		self.old_model = self.old_model..'.mdl'
    end	
    if hero.name == '亚瑟王' then 
        hero:add('物品获取率',self.item_mul)
        --没有皮肤时，更换模型
        hero.skin = japi.SetUnitModel(hero.handle,self.effect)
        --增强剑刃风暴
        local skill = hero:find_skill('剑刃风暴')
        if skill then 
            skill.is_stronged = true
        end    
    end    
end    

function mt:on_cast_start()
    local hero = self.owner
    local player = hero:get_owner()
    hero = player.hero

    if player.mall and player.mall[self.name] then 
        print(2)
        self:buy_failed()
        ac.player.self:sendMsg('|cff00ffff已拥有|r')
        return true 
    end    

end

function mt:buy_failed()
    local skill = self
    local hero = self.owner
    local player = hero:get_owner()
    hero = player.hero

    if hero.name == '亚瑟王' then 
        hero:add('物品获取率',-self.item_mul)
        --已拥有时，再点一次为穿上
        if hero.skin then 
            japi.SetUnitModel(hero.handle,self.old_model)
            hero.skin = false
        end    
    end    

end