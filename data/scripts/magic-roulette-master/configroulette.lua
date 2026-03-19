--[[
	Description: This file is part of Roulette System (refactored)
	Author: Ly�
	Discord: Ly�#8767
]]


local Slot = require('data/scripts/magic-roulette-master/lib/classes/slot')

return {
	slots = {
		[17320] = Slot {
			needItem = {id = 2160, count = 1},
			tilesPerSlot = 11,
			centerPosition = Position(95, 110, 6),

			items = {
				{id = 2472, count = 1, chance = 0.2, rare = true},  -- Magic Plate Armor
				{id = 2471, count = 1, chance = 0.3, rare = true},  -- Golden Helmet
				{id = 2390, count = 1, chance = 0.5, rare = true},  -- Magic Longsword
				{id = 2520, count = 1, chance = 9},   -- Demon Shield
				{id = 2475, count = 1, chance = 9},   -- Warrior Helmet
				{id = 2487, count = 1, chance = 9},   -- Crown Armor
				{id = 2477, count = 1, chance = 9},   -- Knight Legs
				{id = 2645, count = 1, chance = 9},   -- Steel Boots
				{id = 2195, count = 1, chance = 9},   -- Boots of Haste
				{id = 2167, count = 1, chance = 9},   -- Energy Ring
				{id = 2171, count = 1, chance = 9},   -- Platinum Amulet
				{id = 2173, count = 1, chance = 9},   -- Amulet of Loss
				{id = 2268, count = 1, chance = 9},   -- Sudden Death Rune
				{id = 5801, count = 1, chance = 9}    -- Jewelled Backpack
			},
		},

		[17322] = Slot {
			needItem = {id = 2160, count = 1},
			tilesPerSlot = 5,
			centerPosition = Position(80, 111, 6),

			items = {
				{id = 2472, count = 1, chance = 0.02, rare = true},  -- Magic Plate Armor
				{id = 2471, count = 1, chance = 0.03, rare = true},  -- Golden Helmet
				{id = 2390, count = 1, chance = 0.05, rare = true},  -- Magic Longsword
				{id = 2520, count = 1, chance = 9},   -- Demon Shield
				{id = 2475, count = 1, chance = 9},   -- Warrior Helmet
				{id = 2487, count = 1, chance = 9},   -- Crown Armor
				{id = 2477, count = 1, chance = 9},   -- Knight Legs
				{id = 2645, count = 1, chance = 9},   -- Steel Boots
				{id = 2195, count = 1, chance = 9},   -- Boots of Haste
				{id = 2167, count = 1, chance = 9},   -- Energy Ring
				{id = 2171, count = 1, chance = 9},   -- Platinum Amulet
				{id = 2173, count = 1, chance = 9},   -- Amulet of Loss
				{id = 2268, count = 1, chance = 9},   -- Sudden Death Rune
				{id = 5801, count = 1, chance = 9.91} -- Jewelled Backpack
			},
		},
	}
}
