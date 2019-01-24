
local runtime = require 'jass.runtime'
local hero = require 'types.hero'
local japi = require 'jass.japi'
local slk = require 'jass.slk'

hero.hero_list = {
	{'黑暗游侠', '黑暗游侠'},
}

--加载英雄的数据
function load_heroes()
	for _, hero_data in ipairs(hero.hero_list) do
		local name, file = hero_data[1], hero_data[2]
		hero.hero_list[name] = hero_data
		local hero_data = select(2, xpcall(require, runtime.error_handle ,('英雄.%s.init'):format(file)))
		hero.hero_list[name].data = hero_data
		hero_data.name = name
		hero_data.file = file
		hero_data.slk = slk.unit[base.string2id(hero_data.id)]

		if japi.EXSetUnitArrayString then
			japi.EXSetUnitArrayString(base.string2id(hero_data.id), 10, 0, hero_data.production)
			japi.EXSetUnitInteger(base.string2id(hero_data.id), 10, 1)
			japi.EXSetUnitArrayString(base.string2id(hero_data.id), 61, 0, hero_data.name)
			japi.EXSetUnitInteger(base.string2id(hero_data.id), 61, 1)
		else
		end
	end

	--英雄总数
	hero.hero_count = #hero.hero_list
end

load_heroes()







