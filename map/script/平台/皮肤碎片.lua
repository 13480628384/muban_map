local jass = require 'jass.common'
local mt = ac.skill['皮肤碎片']
mt{
    is_spellbook = 1,
    is_order = 2,
    art = [[icon\skin.blp]],
    title = '皮肤碎片',
    tip = [[拥有：
%skin%
|cffcccccc达100个自动激活皮肤效果|r
    ]],
    skin = function(self)
        local hero = self.owner 
        local player = hero:get_owner()
        if not player.skin then return end
        local str =''
        for key,val in pairs(player.skin) do
            str = str .. '|cff'..ac.color_code['淡黄']..'皮肤-'..key..': |r|cff'..ac.color_code['绿']..val..'个|r'..'\n'
        end   
        return str
    end,    

    
}
function mt:on_add()
    local hero = self.owner 
    local player = hero:get_owner()
  
end 
