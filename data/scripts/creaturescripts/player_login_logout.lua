local loginMessage = CreatureEvent("loginMessage")

function loginMessage.onLogin(player)
	print(string.format("\27[32m%s%s\27[0m", player:getName(),
	                       " has logged in."))

	-- Notify player about the rewards in their reward chest
	local rewardChest = player:getRewardChest()
	local rewardContainerCount = 0
	for _, item in ipairs(rewardChest:getItems()) do
		if item:getId() == ITEM_REWARD_CONTAINER then
			rewardContainerCount = rewardContainerCount + 1
		end
	end
	if rewardContainerCount > 0 then
		player:sendTextMessage(MESSAGE_STATUS_DEFAULT, string.format("You have %d reward%s in your reward chest.", rewardContainerCount, rewardContainerCount > 1 and "s" or ""))
	end

    local serverName = configManager.getString(configKeys.SERVER_NAME)
    local loginStr = "Welcome to " .. serverName .. "!"
    if player:getLastLoginSaved() <= 0 then
        loginStr = loginStr .. " Please choose your outfit."
        player:sendOutfitWindow()
    else
        loginStr = string.format("Your last visit in %s: %s.", serverName, os.date("%d %b %Y %X", player:getLastLoginSaved()))
    end
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

    local vocation = player:getVocation()
    local promotion = vocation:getPromotion()
    if player:isPremium() then
        local value = player:getStorageValue(PlayerStorageKeys.promotion)
        if value and value == 1 then
            player:setVocation(promotion)
        end
    elseif not promotion then
        player:setVocation(vocation:getDemotion())
    end

    player:registerEvent("logoutMessage")

    if configManager.getBoolean(RESET_SYSTEM_ENABLED) then
        local reductionMultiplier = player:getResetExpReduction()
        player:setExperienceRate(ExperienceRateType.STAMINA, reductionMultiplier)
    end

    if player:isTokenProtected() then
        player:setTokenLocked(true)
        player:popupFYI("=== TOKEN PROTECTION ===\n\nYour account is protected by TOKEN.\n\nYou cannot move or drop items until you unlock.\n\nType: !token <your_password>\n\nto unlock your character.")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "[Token] You are LOCKED! Type !token <password> to unlock.")
    end

    return true
end

loginMessage:register()

local logoutMessage = CreatureEvent("logoutMessage")

function logoutMessage.onLogout(player)
	print(string.format("\27[31m%s%s\27[0m", player:getName(),
	                       " has logged out."))
	return true
end

logoutMessage:register()
