local concord = require('concord')
local vector = require('hump.vector')
local PlayerControlSystem = concord.system({
    'position', 'velocity', 'inputState'
})

local PLAYER_SPEED = 150

function PlayerControlSystem:update(dt, entity)
    local pos = entity:get('position')
    local vel = entity:get('velocity')
    local input = entity:get('inputState')
    
    -- Calculate movement vector
    vel.x = 0
    vel.y = 0
    
    if input.left then vel.x = vel.x - PLAYER_SPEED end
    if input.right then vel.x = vel.x + PLAYER_SPEED end
    if input.up then vel.y = vel.y - PLAYER_SPEED end
    if input.down then vel.y = vel.y + PLAYER_SPEED end
    
    -- Apply velocity to position
    pos.x = pos.x + vel.x * dt
    pos.y = pos.y + vel.y * dt
end

return PlayerControlSystem
