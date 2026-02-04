local talkaction = TalkAction("/autoloot", "!autoloot")

function talkaction.onSay(player, words, param)
	param = param:gsub("^%s*(.-)%s*$", "%1")

	if param == "list" then
		player:sendAutoLootWindow()
		return false
	end

	if param == "on" then
		if player.setAutoLootEnabled then
			player:setAutoLootEnabled(true)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "AutoLoot enabled.")
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Update source code to use this feature.")
		end
		return false
	end

	if param == "off" then
		if player.setAutoLootEnabled then
			player:setAutoLootEnabled(false)
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "AutoLoot disabled.")
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Update source code to use this feature.")
		end
		return false
	end

	if param == "clear" then
		if player.clearAutoLoot then
			player:clearAutoLoot()
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "AutoLoot list cleared.")
		else
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Update source code to use this feature.")
		end
		return false
	end

	local limitFree = 5
	local limitPremium = 10
	
	if AUTOLOOT_MAXITEMS_FREE and configManager.getNumber(AUTOLOOT_MAXITEMS_FREE) > 0 then
		limitFree = configManager.getNumber(AUTOLOOT_MAXITEMS_FREE)
	elseif Autoloot_MaxItemFree then
		limitFree = Autoloot_MaxItemFree
	end
	
	if AUTOLOOT_MAXITEMS_PREMIUM and configManager.getNumber(AUTOLOOT_MAXITEMS_PREMIUM) > 0 then
		limitPremium = configManager.getNumber(AUTOLOOT_MAXITEMS_PREMIUM)
	elseif Autoloot_MaxItemPremium then
		limitPremium = Autoloot_MaxItemPremium
	end

	local usedSlots = 0
	if player.getAutoLootItemCount then
		usedSlots = player:getAutoLootItemCount()
	end

	local status = "On"
	if player.isAutoLootEnabled and not player:isAutoLootEnabled() then
		status = "Off"
	end

	local text = "_________AutoLoot System_________\n\n" ..
	             "AutoLoot Status: " .. status .. "\n" ..
	             "AutoMoney Mode: Bank\n\n" ..
	             "Commands:\n" ..
	             "!autoloot on/off\n" ..
	             "!autoloot list\n" ..
	             "!autoloot clear\n\n" ..
	             "--------------------------------------------------\n" ..
	             "Slots used: " .. usedSlots .. "/" .. (player:isPremium() and limitPremium or limitFree) .. "\n" ..
	             "--------------------------------------------------\n\n" ..
	             "Free Account slots: " .. limitFree .. "\n" ..
	             "Premium Account Slots: " .. limitPremium

	player:popupFYI(text)
	return false
end
talkaction:separator(" ")
talkaction:register()
