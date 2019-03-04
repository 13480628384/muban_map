--物品名称
local mt = ac.skill['勇气之证']
mt{
    --物品技能
    is_skill = true,
    --物品类型
    item_type = '消耗品',

    tip = [[
攻击加 %attack%
生命加 %life%
护甲加 %defence%
    ]],

    --技能图标
    art = [[other\zheng_201.blp]],
    --攻击
    attack = 250,
    --生命
    life = 500,
    --护甲
    defence = 25,
    --杀敌个数
    kill_cnt = 10,
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

    self.trg = hero:event '单位-杀死单位' (function(trg, killer, target)
        self:add_item_count(1)
        if self._count > self.kill_cnt then 
            self:item_remove()
            -- hero:remove_item(self)
            hero:add_item('霸者之证',true)
        end    
    end)
    

end

function mt:on_cast_start()
    local hero = self.owner
    local player = hero:get_owner()
    --需要先增加一个，否则消耗品点击则无条件先消耗
    self:add_item_count(1) 

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