--物品名称
local mt = ac.skill['霸者之证']
mt{
    --物品技能
    is_skill = true,

    tip = [[
攻击加 %attack%
生命加 %life%
护甲加 %defence%
    ]],

    --技能图标
    art = [[other\zheng_401.blp]],
    --攻击
    attack = 250000,
    --生命
    life = 50000,
    --护甲
    defence = 2500,
    --唯一
    unique = true
}


function mt:on_add()
    local hero = self.owner
    local player = hero:get_owner()
    local item = self 
    hero:add('攻击',self.attack)
    hero:add('生命上限',self.life)
    hero:add('护甲',self.defence)

    

end
--实际是丢掉
function mt:on_remove()
    local hero = self.owner
    if self.trg then 
        self.trg:remove()
        self.trg = nil
    end    
    hero:add('攻击',-self.attack)
    hero:add('生命上限',-self.life)
    hero:add('护甲',-self.defence)

end