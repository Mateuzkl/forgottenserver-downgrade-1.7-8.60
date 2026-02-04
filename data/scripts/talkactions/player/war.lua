local war = TalkAction("/war")

function war.onSay(player, words, param)
	if not param or param == "" then
		local text = "Guild Wars Commands:\n\n"
		
		local guild = player:getGuild()
		if guild then
			text = text .. "Your Guild Balance: " .. guild:getBankBalance() .. "\n\n"
		end

		text = text .. "/war invite,guild name,fraglimit\n"
		text = text .. "Send an invitation to start a war.\n"
		text = text .. "Example: /war invite,Black Ninjas,150\n\n"
		
		text = text .. "/war invite,guild name,fraglimit,money,time\n"
		text = text .. "Send an invitation to start a war.\n"
		text = text .. "Example: /war invite,Black Ninjas,150,10000,3 days\n\n"
		
		text = text .. "/war accept,guild name\n"
		text = text .. "Accept the invitation to start a war.\n\n"
		
		text = text .. "/war reject,guild name\n"
		text = text .. "Reject the invitation to start a war.\n\n"
		
		text = text .. "/war end,guild name\n"
		text = text .. "Ends an active war with another guild.\n\n"
		
		text = text .. "/war cancel,guild name\n"
		text = text .. "Cancel the invitation to start a war.\n\n"
		
		text = text .. "/balance donate amount\n"
		text = text .. "Donate money to guild balance.\n\n"
		
		text = text .. "/balance pick amount\n"
		text = text .. "Pick money from guild balance (Leader only).\n\n"
		
		text = text .. "You must type guild war related commands in your guild channel."
		
		player:popupFYI(text)
		return false
	end

	player:guildWar(param)
	return false
end

war:separator(" ")
war:register()
