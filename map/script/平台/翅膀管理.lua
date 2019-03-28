local japi = require("jass.japi")
local mt = ac.skill['翅膀管理']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 1,
    --标题颜色
    color =  '青',
	--介绍
    tip = [[
|cffffff00小翅膀:|r %active1%
金币加成+5%, 经验加成+5%,  物品获取率+5%|r
|cffffff00天使之光:|r  %active2%
金币获取率+5%, 经验获取率+5%, 物品获取率+5%
移速+50，攻击速度+50%|r
|cffff0000点击切换翅膀显示|r
]],  
	--技能图标
    art = [[icon\chibang.blp]],
    
    --激活标志
    active1 = function(self,hero)
        local color = '|cffcccccc'
        local player = hero:get_owner()
        if player and player.mall and player.mall['小翅膀'] then 
            color = '|cff00ffff'
        end 
        return color
    end,
    active2 = function(self,hero)
        local color = '|cffcccccc'
        local player = hero:get_owner()
        if player and player.mall and player.mall['天使之光'] then 
            color = '|cff00ffff'
        end 
        return color
    end,
    
	--模型 1小翅膀 2天使之光
	effect1 = [[QX_chibang_d.mdx]],
	effect2 = [[Hero_Slayer_N5S_F_Chest.mdx]],
    --测试
    test21 =0
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    local p = hero:get_owner()    

end
function mt:on_cast_start()
    local skill = self 
    local hero = self.owner
    local player = hero:get_owner()
    hero = player.hero

    local list = {}
    if player.mall and player.mall['小翅膀'] then 
        local info = {
            name = '小翅膀',
            effect = self['effect1'],
        }
        table.insert(list,info)  
    end   

    if player.mall and player.mall['天使之光'] then 
        local info = {
            name = '天使之光',
            effect = self['effect2'],
        }
        table.insert(list,info)  
    end   

    if #list <= 0 then
        player:sendMsg("没有翅膀，请前往商城或是积分商店兑换")
        return
    end 

    local info = {
        name = '取消',
        key = 512
    }
    table.insert(list,info)
    
    if not self.dialog  then 
        self.dialog = create_dialog(player,'选择你要的翅膀',list,
        function (index)
            self.dialog = nil
            local effect = list[index].effect
            if effect then 
                -- print(skill.eff)
                if hero.chibang then 
                    hero.chibang:remove()
                end    
	            hero.chibang = hero:add_effect('chest',effect) 
                -- self.is_choosed = true
            end 
        end)
    end   

end    
function mt:on_remove()
    local hero = self.owner
    local p = hero:get_owner()
    hero = p.hero
   
    if self.trg then
        self.trg:remove()
        self.trg = nil
    end
    if self.eff then 
        self.eff:remove()
        self.eff = nil
    end   
    
    
end
