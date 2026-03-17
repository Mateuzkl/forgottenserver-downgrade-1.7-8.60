--[[
	Description: This file is part of Roulette System (refactored)
	Blocks player logout while roulette is rolling
]]

local Constants = require('data/scripts/magic-roulette-master/lib/core/constants')

local creatureevent = CreatureEvent('Roulette Logout')

function creatureevent.onLogout(player)
	if player:getStorageValue(Constants.STORAGE_ROLLING) == 1 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You cannot logout while the roulette is spinning.")
		return false
	end
	return true
end

creatureevent:register()
