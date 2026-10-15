local bitser = require('lib.bitser.bitser')
local Gamestate = require('lib.hump.gamestate')
local concord = require('lib.concord')

local entityFactory = require('entities.entityFactory')
local inputSystem = require('systems.inputSystem')
local playerControlSystem = require('systems.playerControlSystem')
local renderSystem = require('systems.renderSystem')
local cameraSystem = require('systems.cameraSystem')

local playState = {}
local world

function playState:init()
    -- Create the Concord world
    world = concord.world()
    
    -- Register systems in update order
    world:addSystem(inputSystem)
    world:addSystem(playerControlSystem)
    world:addSystem(cameraSystem)
    world:addSystem(renderSystem) -- Render last
    
    -- Initialize world with entities
    self:setupWorld()
end

function playState:setupWorld()
    local assetLoader = require('utils.assetLoader')
    -- Assuming this returns a table with { image = ..., animation = ... } (from anim8)
    local playerSpriteData = assetLoader.loadAnimation(
        'assets/graphics/player.png',
        32, 32,
        4
    )

    -- Create player
    local player = entityFactory.createPlayer(world, 400, 300)
    
    -- Assign anim8 data to the player's sprite component
    local spriteComp = player:get('sprite')
    spriteComp.spriteSheet = playerSpriteData.image 
    spriteComp.animation = playerSpriteData.animation
    player.sprite = spriteComp
    
    -- Create tilemap (simple grid for now)
    local tileWidth = 32
    local tileHeight = 32
    local mapWidth = 25  -- 800/32
    local mapHeight = 18 -- 600/32
    
    for y = 0, mapHeight-1 do
        for x = 0, mapWidth-1 do
            local isTilled = false -- Start with untilled soil
            local tile = entityFactory.createTile(world, x * tileWidth, y * tileHeight, isTilled)
            -- TODO: Set tile sprite based on tilled state
        end
    end
    
    -- TODO: Set up camera to follow player
end

function playState:enter()
    -- Called when entering this state
end

-- --- Hump Gamestate Callbacks ---
-- Concord uses these events to trigger systems

function playState:update(dt)
    world:emit('update', dt)
end

function playState:draw()
    world:emit('draw')
end

function playState:keypressed(key)
    world:emit('keypressed', key)
end

function playState:keyreleased(key)
    world:emit('keyreleased', key)
end

return playState