-- Entity factories. Each returns the new entity, already added to `world`.
require('ecs.components')
local Concord = require('lib.concord')
local anim8 = require('lib.anim8.anim8')
local assets = require('core.assets')
local config = require('config')
local crops = require('data.crops')

local TILE = config.TILE_SIZE

local entities = {}

-- Character sheets are 32x32 frames; rows are facing down, up, right.
local function characterAnimations()
    local idleGrid, idleImage = assets.grid('character/idle.png', 32, 32)
    local walkGrid, walkImage = assets.grid('character/walk.png', 32, 32)
    local animations = {}
    for row, dir in ipairs({ 'down', 'up', 'side' }) do
        animations['idle_' .. dir] = { image = idleImage, anim = anim8.newAnimation(idleGrid('1-4', row), 0.25) }
        animations['walk_' .. dir] = { image = walkImage, anim = anim8.newAnimation(walkGrid('1-6', row), 0.1) }
    end
    return animations
end

--- Quad and image for a crop at a growth stage (1-based).
function entities.cropFrame(id, stage)
    local def = crops.byId[id]
    return assets.quad(crops.SHEET,
        (stage - 1) * crops.CELL_WIDTH, def.row * crops.CELL_HEIGHT,
        crops.CELL_WIDTH, crops.CELL_HEIGHT)
end

function entities.player(world, x, y)
    return Concord.entity(world)
        :give('position', x, y)
        :give('velocity')
        :give('collider', 10, 6)
        :give('facing', 'down')
        :give('intent')
        :give('playerControlled')
        :give('farmer')
        :give('sprite', nil, nil, 16, 26) -- feet sit at (16, 26) in the frame
        :give('animator', characterAnimations(), 'idle_down')
end

--- A tree standing on tile (tx, ty). Marks the tile as blocked.
function entities.tree(world, farm, tx, ty)
    local quad, image = assets.quad('objects/maple_tree.png', 96, 0, 32, 48)
    farm:get(tx, ty).blocked = true
    return Concord.entity(world)
        :give('position', (tx - 1) * TILE + TILE / 2, ty * TILE - 1)
        :give('collider', 10, 6)
        :give('sprite', image, quad, 16, 47)
end

function entities.crop(world, id, tx, ty)
    local quad, image = entities.cropFrame(id, 1)
    return Concord.entity(world)
        :give('position', (tx - 1) * TILE + TILE / 2, ty * TILE - 1)
        :give('crop', id, tx, ty)
        :give('sprite', image, quad, crops.CELL_WIDTH / 2, crops.CELL_HEIGHT - 1)
end

return entities
