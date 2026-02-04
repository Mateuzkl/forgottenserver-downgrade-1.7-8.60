<<<<<<<< HEAD:data/scripts/talkactions/god/animationeffect.lua
local talkaction = TalkAction("/x")

function talkaction.onSay(player, words, param)
========
function onSay(player, words, param)
>>>>>>>> parent of c6cb387 (Move XML to Talkactions Revscripts):data/talkactions/scripts/animationeffect.lua
	local effect = tonumber(param)
	local position = player:getPosition()
	local toPositionLow = {z = position.z}
	local toPositionHigh = {z = position.z}

	toPositionLow.x = position.x - 7
	toPositionHigh.x = position.x + 7
	for i = -5, 5 do
		toPositionLow.y = position.y + i
		toPositionHigh.y = toPositionLow.y
		position:sendDistanceEffect(toPositionLow, effect)
		position:sendDistanceEffect(toPositionHigh, effect)
	end

	toPositionLow.y = position.y - 5
	toPositionHigh.y = position.y + 5
	for i = -6, 6 do
		toPositionLow.x = position.x + i
		toPositionHigh.x = toPositionLow.x
		position:sendDistanceEffect(toPositionLow, effect)
		position:sendDistanceEffect(toPositionHigh, effect)
	end
	return false
end
