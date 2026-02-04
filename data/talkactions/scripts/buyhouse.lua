local config = {
    onlyPremium = true
}

function onSay(player, words, param)
    local housePrice = configManager.getNumber(configKeys.HOUSE_PRICE)
    if housePrice == -1 then
        return true
    end

    if player:getLevel() < configManager.getNumber(configKeys.HOUSE_LEVEL) then
        player:sendCancelMessage("You need level " .. configManager.getNumber(configKeys.HOUSE_LEVEL) .. " or higher to buy a house.")
        return false
    end

    if config.onlyPremium and not player:isPremium() then
        player:sendCancelMessage("You need a premium account.")
        return false
    end

    local position = player:getPosition()
    position:getNextPosition(player:getDirection())

    local tile = Tile(position)
    if not tile then
        player:sendCancelMessage("You have to be looking at the door of the house you would like to buy.")
        return false
    end

    local house = tile:getHouse()
    if not house then
        player:sendCancelMessage("You have to be looking at the door of the house you would like to buy.")
        return false
    end

    local price = house:getTileCount() * housePrice

    if house:getType() == HOUSE_TYPE_NORMAL then
        if house:getOwnerGuid() > 0 then
            player:sendCancelMessage("This house already has an owner.")
            return false
        end

        if player:getHouse() then
            player:sendCancelMessage("You are already the owner of a house.")
            return false
        end

        if not player:removeMoney(price) then
            player:sendCancelMessage("You do not have enough money. Price: " .. price .. " gold.")
            return false
        end

        house:setOwnerGuid(player:getGuid())
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You have successfully bought this house for " .. price .. " gold. Be sure to have the money for rent in the bank.")
        return false

    elseif house:getType() == HOUSE_TYPE_GUILDHALL then
        if house:getOwnerGuild() > 0 then
            player:sendCancelMessage("This guildhall already has an owner.")
            return false
        end

        local guild = player:getGuild()
        if not guild then
            player:sendCancelMessage("You are not in a guild.")
            return false
        end

        if guild:getHouseId() > 0 then
            player:sendCancelMessage("Your guild already owns a guildhall.")
            return false
        end

        local isLeader = player:isGuildLeader()
        local isVice = player:isGuildVice()
        if not (isLeader or isVice) then
            player:sendCancelMessage("Only Guild Leader or Vice-Leader can buy guildhalls.")
            return false
        end

        local query = db.storeQuery("SELECT `balance` FROM `guilds` WHERE `id` = " .. guild:getId())
        local balance = 0
        if query then
            balance = result.getNumber(query, "balance")
            result.free(query)
        end
        
        if price > balance then
            player:sendCancelMessage("Your guild bank does not have enough money, it is missing " .. (price - balance) .. " gold.")
            return false
        end

        local newBalance = balance - price
        db.query("UPDATE `guilds` SET `balance` = " .. newBalance .. " WHERE `id` = " .. guild:getId())

        local currentTime = os.time()
        local queryStr = string.format(
            "INSERT INTO `guild_transactions` (`guild_id`, `player_associated`, `type`, `category`, `balance`, `time`) VALUES (%d, %d, 'WITHDRAW', 'RENT', %d, %d)",
            guild:getId(),
            player:getGuid(),
            price,
            currentTime
        )
        db.query(queryStr)

        local receipt = Game.createItem(ITEM_RECEIPT_SUCCESS, 1)
        if receipt then
            local purchaseDate = os.date("%d %B %Y, %H:%M:%S", currentTime)
            
            local townId = house:getTown()
            local town = townId
            local townName = town and town:getName() or "Unknown"
            
            local receiptText = string.format(
                "Guild Bank Receipt\n\n" ..
                "Date: %s\n" ..
                "Type: Guildhall Purchase\n" ..
                "Category: House Rent\n\n" ..
                "Property: %s\n" ..
                "City: %s\n" ..
                "Amount Paid: %d gold\n\n" ..
                "Guild: %s\n" ..
                "Purchased by: %s\n\n" ..
                "This receipt is required to leave the guildhall.\n" ..
                "Keep it safe!",
                purchaseDate,
                house:getName(),
                townName,
                price,
                guild:getName(),
                player:getName()
            )
            
            receipt:setAttribute(ITEM_ATTRIBUTE_TEXT, receiptText)
            receipt:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, 
                "Guild: " .. guild:getName() .. 
                " | Property: " .. house:getName() .. 
                " | City: " .. townName ..
                " | Purchased: " .. purchaseDate
            )
            
            receipt:setCustomAttribute("guildhall_receipt", 1)
            receipt:setCustomAttribute("guild_id", guild:getId())
            receipt:setCustomAttribute("house_id", house:getId())
            receipt:setCustomAttribute("town_id", townId)
            receipt:setCustomAttribute("purchase_time", currentTime)
            receipt:setCustomAttribute("buyer_guid", player:getGuid())
            
            local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
            local ret = RETURNVALUE_NOTPOSSIBLE
            
            if backpack then
                ret = backpack:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            end
            
            if ret ~= RETURNVALUE_NOERROR then
                ret = player:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
            end
            
            if ret ~= RETURNVALUE_NOERROR then
                local playerPos = player:getPosition()
                local groundTile = Tile(playerPos)
                if groundTile then
                    groundTile:addItem(receipt)
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The receipt has been placed on the floor because your inventory is full.")
                else
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Could not create receipt. Please contact an administrator.")
                end
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The receipt has been added to your inventory.")
            end
        end

        house:setOwnerGuid(player:getGuid())
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You have successfully bought this guildhall for " .. price .. " gold. Be sure to have the money for rent in the guild bank.")
        return false

    else
        player:sendCancelMessage("You cannot buy this property.")
        return false
    end
end
