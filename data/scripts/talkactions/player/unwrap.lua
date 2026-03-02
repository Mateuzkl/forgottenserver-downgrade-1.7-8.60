local unwrapCommand = TalkAction("!unwrap")

function unwrapCommand.onSay(player, words, param)
	local position = player:getPosition()
	local tile = position:getTile()

	if not tile or not tile:getHouse() then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You may only unwrap items inside a house.")
		return false
	end

	local lookPosition = position
	local dir = player:getDirection()
	if dir == DIRECTION_NORTH then
		lookPosition.y = lookPosition.y - 1
	elseif dir == DIRECTION_SOUTH then
		lookPosition.y = lookPosition.y + 1
	elseif dir == DIRECTION_EAST then
		lookPosition.x = lookPosition.x + 1
	elseif dir == DIRECTION_WEST then
		lookPosition.x = lookPosition.x - 1
	end

	local lookTile = Tile(lookPosition)
	if not lookTile then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "No items found in front of you.")
		return false
	end

	local items = lookTile:getItems()
	if not items then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "No items found in front of you.")
		return false
	end

	for _, item in pairs(items) do
		local itemId = item:getId()

		-- Check if it's a kit (needs to be constructed)
		local constructedId = houseAutowrapItems[itemId]
		if constructedId then
			item:transform(constructedId)
			item:setAttribute(ITEM_ATTRIBUTE_WRAPID, itemId)
			lookPosition:sendMagicEffect(CONST_ME_POFF)
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Item placed successfully.")
			return false
		end

		-- Check if it's already constructed (has wrapid attribute)
		if item:hasAttribute(ITEM_ATTRIBUTE_WRAPID) then
			local wrapId = item:getIntAttr(ITEM_ATTRIBUTE_WRAPID)
			if wrapId and wrapId ~= 0 then
				item:transform(wrapId)
				item:removeAttribute(ITEM_ATTRIBUTE_WRAPID)
				lookPosition:sendMagicEffect(CONST_ME_POFF)
				player:sendTextMessage(MESSAGE_INFO_DESCR, "Item wrapped successfully.")
				return false
			end
		end
	end

	player:sendTextMessage(MESSAGE_INFO_DESCR, "No wrappable items found in front of you.")
	return false
end

unwrapCommand:separator(" ")
unwrapCommand:register()
