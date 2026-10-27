-- The farming loop: till grass, plant seeds in soil, harvest ripe crops.
require('ecs.components')
local Concord = require('lib.concord')
local crops = require('data.crops')
local entities = require('ecs.entities')

local Farming = Concord.system({ pool = { 'farmer', 'intent', 'position', 'facing' } })

local OFFSETS = {
    down = { 0, 1 },
    up = { 0, -1 },
    left = { -1, 0 },
    right = { 1, 0 },
}

function Farming:update(dt)
    local world = self:getWorld()
    local farm = world:getResource('farm')

    for _, e in ipairs(self.pool) do
        local farmer, intent = e.farmer, e.intent

        if intent.nextSeed then
            farmer.seed = farmer.seed % #crops + 1
            intent.nextSeed = false
        end
        if intent.selectSeed then
            if crops[intent.selectSeed] then farmer.seed = intent.selectSeed end
            intent.selectSeed = nil
        end

        -- Target the tile in front of the feet (nudged up so standing exactly
        -- on a tile edge counts as the tile above it).
        local tx, ty = farm:worldToTile(e.position.x, e.position.y - 1)
        local offset = OFFSETS[e.facing.dir]
        tx, ty = tx + offset[1], ty + offset[2]
        local tile = farm:get(tx, ty)
        if tile and not tile.blocked then
            farmer.tx, farmer.ty = tx, ty
        else
            farmer.tx, farmer.ty = nil, nil
        end

        if intent.action then
            intent.action = false
            if farmer.tx then
                self:work(world, farmer, tile, tx, ty)
            end
        end
    end
end

function Farming:work(world, farmer, tile, tx, ty)
    if tile.crop then
        local crop = tile.crop.crop
        if crop.stage == crops.byId[crop.id].stages then
            local inventory = world:getResource('inventory')
            inventory[crop.id] = (inventory[crop.id] or 0) + 1
            tile.crop:destroy()
            tile.crop = nil
        end
    elseif not tile.tilled then
        tile.tilled = true
    else
        tile.crop = entities.crop(world, crops[farmer.seed].id, tx, ty)
    end
end

return Farming
