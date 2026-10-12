local concord = require('concord')
local bump = require('bump')

local CollisionSystem = concord.system({
    'position'
})

local TILE_SIZE = 32

function CollisionSystem:init()
    -- Initialize bump world
    self.world = bump.newWorld(TILE_SIZE)
    -- We'll need to add tiles as obstacles
    -- For simplicity, we'll assume all non-tilled tiles are obstacles for now
end

function CollisionSystem:update(dt, entity)
    local pos = entity:get('position')
    -- We'll need to know the entity's size for collision
    -- For now, assume player is 16x16
    local cols, len = self.world:check(entity, pos.x, pos.y, 16, 16)
    
    -- Simple collision response: don't move if collision
    if len > 0 then
        -- Revert to previous position (we'd need to store this)
        -- For now, just prevent movement into collision
        -- Proper implementation would involve resolving the collision
    end
end

function CollisionSystem:addEntity(entity)
    -- Add entity to bump world for collision detection
    local pos = entity:get('position')
    self.world:add(entity, pos.x, pos.y, 16, 16) -- Assuming 16x16 size
end

function CollisionSystem:removeEntity(entity)
    self.world:remove(entity)
end

return CollisionSystem
