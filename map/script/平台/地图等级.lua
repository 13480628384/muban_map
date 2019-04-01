local japi = require("jass.japi")
local mt = ac.skill['地图等级']
mt{
    --必填
    is_skill = true,
    --初始等级
    level = 0,
    max_level = 100,
    --标题颜色
    color =  '青',
	--介绍
    tip = [[
%active3%地图等级3: 全属性加100 , 金币加成+5% （%nick_name3%）|r
%active5%地图等级5: 物品获取率+5% , 经验加成+5% ，金币加成+5% （%nick_name5%） |r
%active10%地图等级10: 攻击力加25% , 对boss额外伤害 50% （%nick_name10%） |r 
%active15%地图等级15: 全属性加1000 , 金币加成 +50% （%nick_name15%） |r
%active25%地图等级25: 全属性加15% , 物品获取率 +50% （%nick_name25%） |r

|cffff0000点击领取对应称号，只能更换一次|r
]],
    map_level = function(self,hero)
		if self and self.owner and self.owner:get_owner() then 
			return self.owner:get_owner():Map_GetMapLevel() or self.level or 0
		end	
    end,    
	--技能图标
    art = [[icon\jineng040.blp]],
    
    --激活标志
    active3 = '|cffcccccc',
    active5 = '|cffcccccc',
    active10 = '|cffcccccc',
    active15 = '|cffcccccc',
    active25 = '|cffcccccc',

    --称号   
    nick_name3 = '开心游戏',
    nick_name5 = '炉火纯青',
    nick_name10 = '完美主义',
    nick_name15 = '无与伦比',
    nick_name25= '君临天下',
    
	--模型
	effect3 = [[kxyx.mdx]],
	effect5 = [[lhcq.mdx]],
	effect10 = [[wmzy.mdx]],
	effect15 = [[wylb.mdx]],
    effect25 = [[jltx.mdx]],
    --测试
    -- test21 =0
	
}
function mt:on_add()
    local skill = self
    local hero = self.owner
    local p = hero:get_owner()
    self:set_level(self.map_level)
    self.list = {}
    --加成到英雄身上
    hero = p.hero
    self.map_level = self.level
    if self.map_level <3 then 
    elseif self.map_level <5 then
        self.active3 = '|cff00ffff' 
        hero:add('智力',100)
        hero:add('敏捷',100)
        hero:add('力量',100)
        hero:add('金币加成',5)
    elseif self.map_level <10 then
        self.active5 = '|cff00ffff' 
        hero:add('物品获取率',5)
        hero:add('经验加成',5)
        hero:add('金币加成',5)
    elseif self.map_level <15 then
        self.active10 = '|cff00ffff' 
        hero:add('攻击%',25)
        hero:add('对BOSS额外伤害',50)
    elseif self.map_level <25 then
        self.active15 = '|cff00ffff' 
        hero:add('智力',1000)
        hero:add('敏捷',1000)
        hero:add('力量',1000)
        hero:add('金币加成',50)
    else
        self.active25 = '|cff00ffff' 
        hero:add('智力%',15)
        hero:add('敏捷%',15)
        hero:add('力量%',15)
        hero:add('物品获取率',50)
    end    

end
mt.on_upgrade = mt.on_add
function mt:on_cast_start()
    -- if self.is_choosed then 
    --     player:sendMsg("已经选择称号，不可修改")
    --     return 
    -- end   
    local skill = self 
    local hero = self.owner
    local player = hero:get_owner()
    hero = player.hero

    local list = {}
    self.map_level = self.level  --测试用

    for i = 1,self.map_level do 
        if self['nick_name'..i] and self['effect'..i] then 
            local info = {
                name = self['nick_name'..i],
                effect = self['effect'..i],
            }
            table.insert(list,info)  
        end    
    end    


    if #list <= 0 then
        player:sendMsg("地图等级不够，没有额外称号")
        return
    end 

    local info = {
        name = '取消',
        key = 512
    }
    table.insert(list,info)
    
    if not self.dialog  then 
        self.dialog = create_dialog(player,'选择你要的称号',list,
        function (index)
            self.dialog = nil
            local effect = list[index].effect
            if effect then 
                -- print(skill.eff)
                if self:get('eff') then 
                    self:get('eff'):remove()
                end    
	            self:set('eff', hero:add_effect('overhead',effect) )
                -- self.is_choosed = true
            else       
                if self:get('eff') then 
                    self:get('eff'):remove()
                end      
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
    
    -- hero:add('金币加成',-self.map_level)
    -- hero:add('经验加成',-self.map_level)
    -- hero:add('物品获取率',-self.map_level)
    
end
