--[[
	Description: This file is part of Roulette System (refactored)
	Author: Ly�
	Discord: Ly�#8767
]]

local configRoulet = require('data/scripts/magic-roulette-master/configroulette')
local configRouletVertical = require('data/scripts/magic-roulette-master/configroulettevertical')
local Roulette = require('data/scripts/magic-roulette-master/lib/roulette')
local Strings = require('data/scripts/magic-roulette-master/lib/core/strings')

local action = Action()

function action.onUse(player, item)
	local slot = Roulette:getSlot(item.actionid)
	if not slot then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, Strings.SLOT_NOT_IMPLEMENTED_YET)
		item:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end
	
	Roulette:roll(player, slot)
	return true
end

for k in pairs(configRoulet.slots) do
	action:aid(k)
end
for k in pairs(configRouletVertical.slots) do
	action:aid(k)
end

action:register()
