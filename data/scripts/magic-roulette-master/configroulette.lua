--[[
	Description: This file is part of Roulette System (refactored)
	Author: Ly�
	Discord: Ly�#8767
]]


local Slot = require('data/scripts/magic-roulette-master/lib/classes/slot')

return {
	slots = {
		[17320] = Slot {
			needItem = {id = 2972, count = 1},
			tilesPerSlot = 11,
			centerPosition = Position(95, 110, 6),

			items = {
				{id = 3366, count = 1, chance = 0.2, rare = true},  -- Magic Plate Armor
				{id = 3365, count = 1, chance = 0.3, rare = true},  -- Golden Helmet
				{id = 3278, count = 1, chance = 0.5, rare = true},  -- Magic Longsword
				{id = 3420, count = 1, chance = 9},   -- Demon Shield
				{id = 3369, count = 1, chance = 9},   -- Warrior Helmet
				{id = 3381, count = 1, chance = 9},   -- Crown Armor
				{id = 3371, count = 1, chance = 9},   -- Knight Legs
				{id = 3554, count = 1, chance = 9},   -- Steel Boots
				{id = 3079, count = 1, chance = 9},   -- Boots of Haste
				{id = 3051, count = 1, chance = 9},   -- Energy Ring
				{id = 3055, count = 1, chance = 9},   -- Platinum Amulet
				{id = 3057, count = 1, chance = 9},   -- Amulet of Loss
				{id = 3155, count = 1, chance = 9},   -- Sudden Death Rune
				{id = 5801, count = 1, chance = 9}    -- Jewelled Backpack
			},
		},

		[17322] = Slot {
			needItem = {id = 2972, count = 1},
			tilesPerSlot = 5,
			centerPosition = Position(80, 111, 6),

			items = {
				{id = 3366, count = 1, chance = 0.02, rare = true},  -- Magic Plate Armor
				{id = 3365, count = 1, chance = 0.03, rare = true},  -- Golden Helmet
				{id = 3278, count = 1, chance = 0.05, rare = true},  -- Magic Longsword
				{id = 3420, count = 1, chance = 9},   -- Demon Shield
				{id = 3369, count = 1, chance = 9},   -- Warrior Helmet
				{id = 3381, count = 1, chance = 9},   -- Crown Armor
				{id = 3371, count = 1, chance = 9},   -- Knight Legs
				{id = 3554, count = 1, chance = 9},   -- Steel Boots
				{id = 3079, count = 1, chance = 9},   -- Boots of Haste
				{id = 3051, count = 1, chance = 9},   -- Energy Ring
				{id = 3055, count = 1, chance = 9},   -- Platinum Amulet
				{id = 3057, count = 1, chance = 9},   -- Amulet of Loss
				{id = 3155, count = 1, chance = 9},   -- Sudden Death Rune
				{id = 5801, count = 1, chance = 9.91} -- Jewelled Backpack
			},
		},
	}
}
