--物品名称
local mt = ac.skill['霸者之证']
mt{
    --物品技能
    is_skill = true,
    level = 1 ,
    max_level = 5,
    --物品类型
    item_type = '消耗品',

    --颜色
    color = '紫',

    tip = [[|cffdf19d0攻击加 %attack%
|cffdf19d0生命加 %life%
|cffdf19d0护甲加 %defence%|r
%lv2_tip% 
]],

    --技能图标
    art = [[other\zheng_401.blp]],
    --攻击
    attack = 250000,
    --生命
    life = 50000,
    --护甲
    defence = 2500,

    --物爆几率
	physical_rate = {0,5,10,15,15},
	--会爆
	heart_rate = {0,5,10,15,15},
	--法爆
    magic_rate = {0,5,10,15,15},
    
	--对boss 额外伤害
    boss_damage = 250,
    
    --等级>=2 时新增的描述
    lv2_tip = function(self,hero)
        local tip = ''
        if self.level == 1  then 
            tip = tip .. '|cff00ffff【飞升】英雄达到100级,携带此物，前往天结散人。|r'
        else    
            if self.level >=2  then 
                tip = tip .. '|cffdf19d0物爆几率+'..self.physical_rate ..'|r\n'
                tip = tip .. '|cffdf19d0法爆几率+'..self.magic_rate ..'|r\n'
                tip = tip .. '|cffdf19d0会心几率+'..self.heart_rate ..'|r\n'
                tip = tip .. '|cffffff00杀怪+5点全属性'..'|r\n'
                tip = tip .. '|cffffff00杀死敌人有概率（15%）收集灵魂（受物品获取率影响））|r\n'
            end   
            if self.level >=2 and self.level <=3  then  
                tip = tip .. '|cff00ffff【进化】杀死|r %upgrade_cnt% |cff00ffff个敌人|r'
            end   
            if self.level ==4 then  
                tip = tip .. '|cff00ffff【进化】杀死|r %upgrade_cnt% |cff00ffff个敌人，且成功挑战伏地魔（天结散人）|r'
            end
            if self.level ==5 then  
                tip = tip .. '|cffdf19d0对BOSS额外伤害+'..self.boss_damage ..'%|r\n'
                tip = tip .. '|cff00ffff【满级无法进化】|r'
            end
        end    
        return tip
    end,  

   
    --杀怪加全属性 
    kill_add_attr = 5,
    --概率收集
    chance = function(self,hero)
        if self and hero then 
            return 15 * ( 1 + hero:get('物品获取率')/100 )
        end
    end,       
    --唯一
    unique = true,
    --升级所需要的杀敌数
    upgrade_cnt = {0,50,100,150,999999},
    --显示等级
    show_level = true,
    --升级特效
    effect =[[Hero_CrystalMaiden_N2_V_boom.mdx]]
}


mt.physical_rate_now = 0
mt.heart_rate_now = 0
mt.magic_rate_now = 0

function mt:on_upgrade()
    local hero = self.owner
	-- print(self.life_rate_now)
	hero:add('物爆几率', -self.physical_rate_now)
	self.physical_rate_now = self.physical_rate
	hero:add('物爆几率', self.physical_rate)

	hero:add('会心几率', -self.heart_rate_now)
	self.heart_rate_now = self.heart_rate
	hero:add('会心几率', self.heart_rate)

	hero:add('法爆几率', -self.magic_rate_now)
	self.magic_rate_now = self.magic_rate
    hero:add('法爆几率', self.magic_rate)
    
    if self.level >=2 then 
        if not self.trg then 
            self.trg = ac.game:event '单位-杀死单位' (function(trg, killer, target)
                --召唤物杀死也继承
                local hero = killer:get_owner().hero
                if hero and hero:has_item(self.name) then 
                    local rand = math.random(100)
                    if rand <= self.chance then 
                        self:add_item_count(1)
                        if self._count >= self.upgrade_cnt and self.level < (self.max_level-1) then 
                            self:add_item_count(-self.upgrade_cnt+1)
                            self:upgrade(1)
                        end  
                    end  
                    --杀怪加全属性 
                    hero:add('力量',self.kill_add_attr)
                    hero:add('智力',self.kill_add_attr)
                    hero:add('敏捷',self.kill_add_attr)
                end    
            end) 
        end    
    end  

    if self.level == self.max_level then 
        hero:add('对BOSS额外伤害',self.boss_damage)
        if self.trg then 
            self.trg:remove()
            self.trg = nil
        end    
    end     
    -- local tip = '升级时加的文字描述'
    -- self.tip = self:get_tip() .. tip .. '\n'
    -- self:fresh_tip()
end


function mt:on_add()
    local hero = self.owner
    local player = hero:get_owner()
    local item = self 
    hero:add('攻击',self.attack)
    hero:add('生命上限',self.life)
    hero:add('护甲',self.defence)

    if self.level >=2 then 
        if not self.trg then 
            self.trg = ac.game:event '单位-杀死单位' (function(trg, killer, target)
                --召唤物杀死也继承
                local hero = killer:get_owner().hero
                if hero and hero:has_item(self.name) then 
                    local rand = math.random(100)
                    if rand <= self.chance then 
                        self:add_item_count(1)
                        if self._count >= self.upgrade_cnt and self.level < (self.max_level-1) then 
                            self:add_item_count(-self.upgrade_cnt+1)
                            self:upgrade(1)
                        end  
                    end  
                    --杀怪加全属性 
                    hero:add('力量',self.kill_add_attr)
                    hero:add('智力',self.kill_add_attr)
                    hero:add('敏捷',self.kill_add_attr)
                end    
            end) 
        end    
    end  

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
	
	hero:add('物爆几率',-self.physical_rate)
	hero:add('会心几率',-self.heart_rate)
    hero:add('法爆几率',-self.magic_rate)
    
    if self.level == self.max_level then 
        hero:add('对BOSS额外伤害',-self.boss_damage)
    end  

end