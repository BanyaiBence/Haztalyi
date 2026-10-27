-- Keyboard -> intent. The only system that knows about keys.
require('ecs.components')
local Concord = require('lib.concord')
local config = require('config')

local Input = Concord.system({ pool = { 'playerControlled', 'intent' } })

local function axis(negative, positive)
    return (config.isDown(positive) and 1 or 0) - (config.isDown(negative) and 1 or 0)
end

function Input:update(dt)
    for _, e in ipairs(self.pool) do
        e.intent.dx = axis('left', 'right')
        e.intent.dy = axis('up', 'down')
    end
end

function Input:keypressed(key)
    local number = tonumber(key)
    for _, e in ipairs(self.pool) do
        if config.isBound('action', key) then e.intent.action = true end
        if config.isBound('nextSeed', key) then e.intent.nextSeed = true end
        if number then e.intent.selectSeed = number end
    end
end

return Input
