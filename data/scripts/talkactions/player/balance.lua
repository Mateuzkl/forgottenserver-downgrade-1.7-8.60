local balance = TalkAction("/balance")

function balance.onSay(player, words, param)
	if not param or param == "" then
		local guild = player:getGuild()
		if not guild then
			player:sendCancelMessage("You are not in a guild.")
			return false
		end

		local text = "Guild Banking System\n\n"
		text = text .. "Guild Balance: " .. guild:getBankBalance() .. " gold\n"
		text = text .. "Your Bank Balance: " .. player:getBankBalance() .. " gold\n\n"
		
		text = text .. "Commands:\n"
		text = text .. "/balance donate amount\n"
		text = text .. "Donate money from your bank to guild balance.\n\n"
		
		text = text .. "/balance pick amount\n"
		text = text .. "Withdraw money from guild balance (Leaders only).\n"
		
		player:popupFYI(text)
		return false
	end

	player:guildBalance(param)
	return false
end

balance:separator(" ")
balance:register()
