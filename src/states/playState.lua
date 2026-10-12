local Gamestate = require('hump.gamestate')
local concord = require('concord')
local entityFactory = require('entities.entityFactory')
local inputSystem = require('systems.inputSystem')
local playerControlSystem = require('systems.playerControlSystem')
local plantingSystem = require('systems.plantingSystem')
local growthSystem = require('systems.growthSystem')
local harvestSystem = require('systems.harvestSystem')
local renderSystem = require('systems.renderSystem')
local collisionSystem = require('systems.collisionSystem')
local cameraSystem = require('systems.cameraSystem')

local playState = {}
local world

function playState:init()
    world = concord.world()
    
    -- Register systems in update order
    world:addSystem(inputSystem)
    world:addSystem(playerControlSystem)
    world:addSystem(plantingSystem)
    world:addSystem(growthSystem)
    world:addSystem(harvestSystem)
    world:addSystem(collisionSystem)
    world:addSystem(cameraSystem)
    world:addSystem(renderSystem) -- Render last
    
    -- Initialize world with entities
    self:setupWorld()
end

function playState:setupWorld()
    -- Create player
    local player = entityFactory.createPlayer(world, 400, 300)
    -- TODO: Set player sprite animation
    
    -- Create tilemap (simple grid for now)
    local tileWidth = 32
    local tileHeight = 32
    local mapWidth = 25  -- 800/32
    local mapHeight = 18 -- 600/32
    
    for y = 0, mapHeight-1 do
        for x = 0, mapWidth-1 do
            local isTilled = false -- Start with untilled soil
            local tile = entityFactory.createTile(world, x * tileWidth, y * tileHeight, isTilled)
        end
    end
    
    -- TODO: Set up camera to follow player
end
local Gamestate = require('hump.gamestate')

function playState:enter()
    -- Called when entering this state
end

function playState:update(dt)
    world:update(dt)
end

function playState:draw()
    world:draw()
end

function playState:keypressed(key)
    world:emit('keypressed', key)
end

function playState:keyreleased(key)
    world:emit('keyreleased', key)
end

return playState
