--物品名称
local mt = ac.skill['勇气之证']
mt{
    --物品技能
    is_skill = true,
    --颜色
    color = '青',
    tip = [[
+%attack% 攻击
+%life% 生命
+%defence% 护甲

|cffFFE799【进阶】|r 杀死 %kill_cnt% 个敌人，自动进阶为|cffdf19d0 霸者之证|r]],

    --技能图标
    art = [[other\zheng_201.blp]],
    --攻击
    attack = 250,
    --生命
    life = 500,
    --护甲
    defence = 25,
    --杀敌个数
    kill_cnt = 350,
    --唯一
    unique = true,
    --物品详细介绍的title
    content_tip = '基本属性：'
}


function mt:on_add()
    local hero = self.owner
    local player = hero:get_owner()
    local item = self 
    hero:add('攻击',self.attack)
    hero:add('生命上限',self.life)
    hero:add('护甲',self.defence)

    self.trg = ac.game:event '单位-杀死单位' (function(trg, killer, target)
        --召唤物杀死也继承
        local hero = killer:get_owner().hero
        if hero and hero:has_item(self.name) then 
            self:add_item_count(1)
            if self._count >= self.kill_cnt then 
                self:item_remove()
                -- hero:remove_item(self)
                hero:add_item('霸者之证',true)
            end    
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