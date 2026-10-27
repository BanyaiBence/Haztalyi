-- Intent -> velocity -> position, resolved against solid colliders with bump.
require('ecs.components')
local Concord = require('lib.concord')
local config = require('config')

local Movement = Concord.system({
    controlled = { 'intent', 'velocity', 'facing' },
    movers = { 'position', 'velocity', 'collider' },
    solids = { 'position', 'collider' },
})

-- Bump works with top-left rectangles; our colliders hang from the feet.
local function rect(e)
    local p, c = e.position, e.collider
    return p.x - c.w / 2, p.y - c.h, c.w, c.h
end

function Movement:init(world)
    local bump = world:getResource('bump')
    self.solids.onAdded = function(_, e) bump:add(e, rect(e)) end
    self.solids.onRemoved = function(_, e) bump:remove(e) end
end

function Movement:update(dt)
    for _, e in ipairs(self.controlled) do
        local dx, dy = e.intent.dx, e.intent.dy
        local length = math.sqrt(dx * dx + dy * dy)
        if length > 0 then
            e.velocity.x = dx / length * config.PLAYER_SPEED
            e.velocity.y = dy / length * config.PLAYER_SPEED
            -- Horizontal wins on diagonals so the side animation shows.
            if dx ~= 0 then
                e.facing.dir = dx < 0 and 'left' or 'right'
            else
                e.facing.dir = dy < 0 and 'up' or 'down'
            end
        else
            e.velocity.x, e.velocity.y = 0, 0
        end
    end

    local bump = self:getWorld():getResource('bump')
    for _, e in ipairs(self.movers) do
        local v = e.velocity
        if v.x ~= 0 or v.y ~= 0 then
            local x, y = rect(e)
            local actualX, actualY = bump:move(e, x + v.x * dt, y + v.y * dt)
            e.position.x = actualX + e.collider.w / 2
            e.position.y = actualY + e.collider.h
        end
    end
end

return Movement
