function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("You do not have permission to use this command.")
		return false
	end

	local target = player
	if param ~= "" then
		target = Player(param)
		if not target then
			player:sendCancelMessage("Player not found.")
			return false
		end
	end

	-- Give all 5 blessings
	for i = 1, 5 do
		target:addBlessing(i)
	end

	local message = string.format("%s has received all blessings.", target:getName())
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, message)
	
	if target ~= player then
		target:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have received all blessings from " .. player:getName() .. ".")
	end

	return false
end