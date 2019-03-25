local mt = ac.creep['刷怪-无尽']{    
    region = '',
    creeps_datas = '',
    is_random = true,
    creep_player = ac.player.com[2],
    tip ="无尽模式开始"

}
function mt:on_start()
    --继承刷怪的信息 函数 
    self.region = ac.creep['刷怪'].region
    self.all_creep = ac.creep['刷怪'].all_creep
    self.game_degree_attr_mul = ac.creep['刷怪'].game_degree_attr_mul

    self.has_unit = ac.creep['刷怪'].has_unit
    self.get_temp_type = ac.creep['刷怪'].get_temp_type
    self.random_creeps_datas = ac.creep['刷怪'].random_creeps_datas
    self.get_creep_skill = ac.creep['刷怪'].get_creep_skill
    self.add_creep_skill = ac.creep['刷怪'].add_creep_skill
    self.send_skill_message = ac.creep['刷怪'].send_skill_message
    self.attack_hero = ac.creep['刷怪'].attack_hero

    --每3秒命令进攻怪攻击附近的英雄
    self:attack_hero() 

end
function mt:on_next()    
    --进攻提示
    ac.ui.kzt.up_jingong_title('无尽 - 第 '..self.index..' 层 ')
    --每一波开始时，进行初始化数据
    self.all_food = ac.creep['刷怪'].all_food
    self.used_food = 0 
    self.current_creep ={}

    
    --获得随机 1-2 个种类的进攻怪
    local temp_type = self:get_temp_type()
    self:random_creeps_datas(temp_type)
    print(self.creeps_datas)
    
    --转化字符串 为真正的区域
    self:set_region()
    --转化字符串 为真正的野怪数据
    self:set_creeps_datas()

    --获得随机野怪技能
    self.rand_skill_list = self:get_creep_skill()

    --发送本层怪物信息 3次10秒
    self:send_skill_message(3,10)
    print('当前波数 '..self.index)


end
--改变怪物
function mt:on_change_creep(unit,lni_data)
    local base_attack = 500000 --每波 + 100000
    local base_defence = 1500
    local base_life = 10000000
    local base_mana = 5000000
    local base_move_speed = 400
    local base_attack_gap = 1
    local base_life_recover = 100000
    local base_mana_recover = 50000
    local base_attack_distance = 100

    local upgrade_attr = {
        ['攻击'] = 100000,
        ['护甲'] = 100,
        ['生命上限'] = 1000000,
        ['魔法上限'] = 500000,
        ['生命恢复'] = 10000,
        ['魔法恢复'] = 5000,
    }
    --设置属性
    unit:set('移动速度',base_move_speed)
    unit:set('攻击间隔',base_attack_gap)
    unit:set('攻击距离',base_attack_distance)
    --设置 boss 属性倍数 及 每波成长
    if lni_data.attr_mul  then
        unit:set('攻击',(base_attack + upgrade_attr['攻击'] * self.index) * lni_data.attr_mul * (self.game_degree_attr_mul or 1 ))
        unit:set('护甲',(base_defence + upgrade_attr['护甲'] * self.index) * lni_data.attr_mul* (self.game_degree_attr_mul or 1 ))
        unit:set('生命上限',(base_life + upgrade_attr['生命上限'] * self.index) * lni_data.attr_mul* (self.game_degree_attr_mul or 1 ))
        unit:set('魔法上限',(base_mana + upgrade_attr['魔法上限'] * self.index) * lni_data.attr_mul* (self.game_degree_attr_mul or 1 ))
        unit:set('生命恢复',(base_life_recover + upgrade_attr['生命恢复'] * self.index) * lni_data.attr_mul* (self.game_degree_attr_mul or 1 ))
        unit:set('魔法恢复',(base_mana_recover + upgrade_attr['魔法恢复'] * self.index) * lni_data.attr_mul* (self.game_degree_attr_mul or 1 ))
    end  

    --掉落概率
    unit.fall_rate = 0
    --掉落金币和经验
    unit.gold = 0
    unit.exp = 0

    --设置搜敌路径
    -- unit:set_search_range(99999)
    --随机添加怪物技能
    self:add_creep_skill(self.rand_skill_list,unit)
   
end

--刷怪结束
function mt:on_finish()  
    if self.key_unit_trg then 
        self.key_unit_trg:remove()
    end    
    if self.mode_timer then 
        self.mode_timer:remove()
    end  
    if self.attack_hero_timer then 
        self.attack_hero_timer:remove()
    end   
end    

