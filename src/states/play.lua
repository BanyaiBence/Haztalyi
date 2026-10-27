local Gamestate = require('lib.hump.gamestate')
local Concord = require('lib.concord')
local Camera = require('lib.hump.camera')
local bump = require('lib.bump.bump')

local config = require('config')
local Farm = require('world.farm')
local entities = require('ecs.entities')
local hud = require('ui.hud')

-- Update order matters: read input, act on it, then present the result.
local systems = {
    require('ecs.systems.input'),
    require('ecs.systems.movement'),
    require('ecs.systems.farming'),
    require('ecs.systems.growth'),
    require('ecs.systems.animation'),
    require('ecs.systems.camera'),
    require('ecs.systems.render'),
}

local play = {}

local function addBorderWalls(bumpWorld, width, height)
    local t = 16
    bumpWorld:add({}, -t, -t, width + 2 * t, t)
    bumpWorld:add({}, -t, height, width + 2 * t, t)
    bumpWorld:add({}, -t, 0, t, height)
    bumpWorld:add({}, width, 0, t, height)
end

local function plantTrees(world, farm, rng)
    local cx, cy = farm.width / 2, farm.height / 2
    for ty = 2, farm.height do
        for tx = 1, farm.width do
            local onBorder = tx == 1 or tx == farm.width or ty == 2 or ty == farm.height
            local nearCentre = math.abs(tx - cx) < 9 and math.abs(ty - cy) < 7
            if (onBorder and tx % 2 == 1) or (not nearCentre and rng:random() < 0.03) then
                entities.tree(world, farm, tx, ty)
            end
        end
    end
end

-- Called on Gamestate.switch from the menu; returning from pause uses resume.
function play:enter()
    local world = Concord.world()
    local farm = Farm.new(config.MAP_WIDTH, config.MAP_HEIGHT)
    local bumpWorld = bump.newWorld(config.TILE_SIZE * 2)
    addBorderWalls(bumpWorld, farm:pixelSize())

    -- Shared services, available to systems via world:getResource().
    world:setResource('farm', farm)
    world:setResource('bump', bumpWorld)
    world:setResource('camera', Camera(0, 0, config.ZOOM))
    world:setResource('inventory', {})

    world:addSystems(unpack(systems))

    plantTrees(world, farm, love.math.newRandomGenerator(1))
    local width, height = farm:pixelSize()
    self.player = entities.player(world, width / 2, height / 2)
    self.world = world
end

function play:update(dt)
    self.world:emit('update', dt)
end

function play:draw()
    love.graphics.clear(0.47, 0.75, 0.34)
    self.world:emit('draw')
    hud.draw(self.world, self.player)
end

function play:keypressed(key)
    if config.isBound('pause', key) then
        Gamestate.push(require('states.pause'))
    else
        self.world:emit('keypressed', key)
    end
end

return play
