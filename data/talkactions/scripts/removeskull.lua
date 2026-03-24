local REMOVE_SKULL_COST = 50000

function onSay(player, words, param)
	local skull = player:getSkull()

	if skull == SKULL_BLACK then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
			"O Black Skull não pode ser removido desta forma.")
		return false
	end

	if skull ~= SKULL_RED then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
			"Você não possui Red Skull para remover.")
		return false
	end

	if not player:removeMoney(REMOVE_SKULL_COST) then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format(
			"Você precisa de %d gold coins para remover seu Red Skull.", REMOVE_SKULL_COST))
		return false
	end

	player:setSkull(SKULL_NONE)
	player:setSkullTime(0)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Seu Red Skull foi removido. %d gold coins foram cobrados.", REMOVE_SKULL_COST))
	return false
end
