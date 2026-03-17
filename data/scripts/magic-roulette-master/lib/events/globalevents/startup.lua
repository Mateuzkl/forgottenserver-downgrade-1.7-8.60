local Roulette = require('data/scripts/magic-roulette-master/lib/roulette')

local globalevent = GlobalEvent()

function globalevent.onStartup()
	Roulette:startup()
end

globalevent:register()
