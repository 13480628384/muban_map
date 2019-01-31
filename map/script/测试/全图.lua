
local player = require 'ac.player'
local fogmodifier = require 'types.fogmodifier'
local sync = require 'types.sync'
local jass = require 'jass.common'
local hero = require 'types.hero'
local item = require 'types.item'
local affix = require 'types.affix'
local japi = require 'jass.japi'
local japi = require 'jass.japi'
local rect = require 'types.rect'

ac.map_area = rect.create(-4000,-4000,4000,4000)
--创建全图视野
local function icu()
	fogmodifier.create(ac.player(1), ac.map_area)
end

icu()


