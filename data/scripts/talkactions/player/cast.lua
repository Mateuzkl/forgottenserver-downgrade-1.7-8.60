local cast = TalkAction("!cast")

function cast.onSay(player, words, param)
	if player:isLiveCasting() then
		player:stopLiveCasting()
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Cast] You have stopped live casting.")
	else
		local password = param:trim()
		password = password:gsub('%W','')
		if password:len() > 30 then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "[Cast] Invalid password. Maximum 30 characters allowed.")
			return false
		end
		
		player:startLiveCasting(password)
		
		player:sendChannelMessage("", "========================================", TALKTYPE_CHANNEL_O, CHANNEL_CAST)
		player:sendChannelMessage("", "       LIVE CAST STARTED!", TALKTYPE_CHANNEL_O, CHANNEL_CAST)
		player:sendChannelMessage("", "========================================", TALKTYPE_CHANNEL_O, CHANNEL_CAST)
		
		if password:len() > 0 then
			player:sendChannelMessage("", "Password: " .. password, TALKTYPE_CHANNEL_O, CHANNEL_CAST)
		else
			player:sendChannelMessage("", "Password: None (public cast)", TALKTYPE_CHANNEL_O, CHANNEL_CAST)
		end
		
		player:sendChannelMessage("", "----------------------------------------", TALKTYPE_CHANNEL_O, CHANNEL_CAST)
		player:sendChannelMessage("", "Commands:", TALKTYPE_CHANNEL_O, CHANNEL_CAST)
		player:sendChannelMessage("", "  !cast - Stop live casting", TALKTYPE_CHANNEL_O, CHANNEL_CAST)
		player:sendChannelMessage("", "  /commands - View all cast commands", TALKTYPE_CHANNEL_O, CHANNEL_CAST)
		player:sendChannelMessage("", "========================================", TALKTYPE_CHANNEL_O, CHANNEL_CAST)
	end
	return false
end

cast:separator(" ")
cast:register()
