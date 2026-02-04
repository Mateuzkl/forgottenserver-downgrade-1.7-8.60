function onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified,
                 mostDamageUnjustified)
	if player:hasFlag(PlayerFlag_NotGenerateLoot) or player:getVocation():getId() ==
		VOCATION_NONE then return true end

	local totalReduceSkillLoss = 0
	for i = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
		local item = player:getSlotItem(i)
		if item then
			local reduceSkillLoss = item:getReduceSkillLoss()
			if reduceSkillLoss > 0 then
				totalReduceSkillLoss = totalReduceSkillLoss + reduceSkillLoss
			end
		end
	end
	
	local finalLossPercent = player:getLossPercent() * 100
	
	local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
	local isRedOrBlack =
		table.contains({SKULL_RED, SKULL_BLACK}, player:getSkull())
	if amulet and amulet.itemid == ITEM_AMULETOFLOSS and not isRedOrBlack then
		local isPlayer = false
		if killer then
			if killer:isPlayer() then
				isPlayer = true
			else
				local master = killer:getMaster()
				if master and master:isPlayer() then isPlayer = true end
			end
		end

		if not isPlayer or not player:hasBlessing(6) then
			player:removeItem(ITEM_AMULETOFLOSS, 1, -1, false)
		end
	else
		for i = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
			local item = player:getSlotItem(i)
			if item then
				local randomValue = math.random(item:isContainer() and 100 or 1000)
				local willLose = isRedOrBlack or randomValue <= finalLossPercent
				
				if willLose then
					if (isRedOrBlack or finalLossPercent ~= 0) and not item:moveTo(corpse) then
						item:remove()
					end
				end
			end
		end
	end

	if not player:getSlotItem(CONST_SLOT_BACKPACK) then
		player:addItem(ITEM_BAG, 1, false, CONST_SLOT_BACKPACK)
	end
	return true
end
