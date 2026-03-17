--[[
	Description: This file is part of Roulette System (refactored)
	Author: Ly�
	Discord: Ly�#8767
]]

local configRoulet = require('data/scripts/magic-roulette-master/configroulette')
local configRouletVertical = require('data/scripts/magic-roulette-master/configroulettevertical')
local Animation = require('data/scripts/magic-roulette-master/lib/animation')
local DatabaseRoulettePlays = require('data/scripts/magic-roulette-master/lib/database/roulette_plays')
local Strings = require('data/scripts/magic-roulette-master/lib/core/strings')
local Constants = require('data/scripts/magic-roulette-master/lib/core/constants')

local function uuid()
	local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	return string.gsub(template, '[xy]', function(c)
		local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format('%x', v)
	end)
end

local Roulette = {}

function Roulette:startup()
	DatabaseRoulettePlays:updateAllRollingToPending()

	self.slots = {}
	for k, v in pairs(configRoulet.slots) do
		self.slots[k] = v
	end
	for k, v in pairs(configRouletVertical.slots) do
		self.slots[k] = v
	end

	for actionid, slot in pairs(self.slots) do
		slot:generatePositions()
		slot:loadChances(actionid)
	end
end

function Roulette:roll(player, slot)
	if slot:isRolling() then
		player:sendCancelMessage(Strings.WAIT_TO_SPIN)
		return false
	end

	local reward = slot:generateReward()
	if not reward then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, Strings.GENERATE_REWARD_FAILURE)	
		return false
	end

	local needItem = slot:getNeedItem()
	local needItemName = ItemType(needItem.id):getName()

	if not player:removeItem(needItem.id, needItem.count) then
		player:sendTextMessage(MESSAGE_EVENT_DEFAULT, Strings.NEEDITEM_TO_SPIN:format(
			needItem.count,
			needItemName
		))
		return false
	end

	local playerName = player:getName()
	
	slot.uuid = uuid()
	DatabaseRoulettePlays:create(slot.uuid, player:getGuid(), reward)
	
	player:setMovementBlocked(true)
	player:setStorageValue(Constants.STORAGE_ROLLING, 1)

	slot:setRolling(true)
	slot:clearDummies()

	local onFinish = function()
		slot:deliverReward()
		slot:setRolling(false)

		local p = Player(playerName)
		if p then
			p:setMovementBlocked(false)
			p:setStorageValue(Constants.STORAGE_ROLLING, -1)
		end

		if reward.rare then
			Game.broadcastMessage(Strings.GIVE_REWARD_FOUND_RARE:format(
				playerName,
				reward.count,
				ItemType(reward.id):getName()
			), MESSAGE_EVENT_ADVANCE)
		end
	end
	
	Animation:start({
		slot = slot,
		reward = reward,
		onFinish = onFinish
	})
	return true
end

function Roulette:getSlot(actionid)
	return self.slots[actionid]
end

return Roulette
