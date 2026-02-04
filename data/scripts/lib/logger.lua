-- Logger Lib
_G.logger = {}

local ANSI_RESET = "\27[0m"
local ANSI_RED = "\27[31m"
local ANSI_GREEN = "\27[32m"
local ANSI_YELLOW = "\27[33m"
local ANSI_BLUE = "\27[34m"
local ANSI_CYAN = "\27[36m"
local ANSI_BOLD = "\27[1m"

logger.colors = {
    reset = ANSI_RESET,
    red = ANSI_RED,
    green = ANSI_GREEN,
    yellow = ANSI_YELLOW,
    blue = ANSI_BLUE,
    cyan = ANSI_CYAN,
    bold = ANSI_BOLD
}

local function getTimestamp()
    return os.date("%Y-%m-%d %H:%M:%S") .. string.format(".%03d", math.random(1, 999)) -- Emulating ms for visual consistency
end

function logger.info(message, ...)
    print(string.format("[%s] [%sinfo%s] " .. message, getTimestamp(), ANSI_GREEN, ANSI_RESET, ...))
end

function logger.warn(message, ...)
    print(string.format("[%s] [%swarning%s] " .. message, getTimestamp(), ANSI_YELLOW, ANSI_RESET, ...))
end

function logger.error(message, ...)
    print(string.format("[%s] [%serror%s] " .. message, getTimestamp(), ANSI_RED, ANSI_RESET, ...))
end

function logger.debug(message, ...)
    print(string.format("[%s] [%sdebug%s] " .. message, getTimestamp(), ANSI_CYAN, ANSI_RESET, ...))
end
