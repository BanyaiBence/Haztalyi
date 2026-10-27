-- The farm's tile grid. Tiles are plain data, not entities: there are many of
-- them and they rarely change, so a 2D array is simpler and faster.
-- Tile coordinates are 1-based; world coordinates are pixels.
local config = require('config')
local assets = require('core.assets')

local TILE = config.TILE_SIZE

local SOIL_COLOR = { 0.47, 0.31, 0.19 }
local SOIL_EDGE_COLOR = { 0.36, 0.22, 0.13 }

local Farm = {}
Farm.__index = Farm

function Farm.new(width, height)
    local self = setmetatable({ width = width, height = height, tiles = {} }, Farm)

    for ty = 1, height do
        self.tiles[ty] = {}
        for tx = 1, width do
            -- crop: the crop entity planted here, if any.
            -- blocked: something solid (e.g. a tree) occupies the tile.
            self.tiles[ty][tx] = { tilled = false, crop = nil, blocked = false }
        end
    end

    -- The grass never changes, so bake it into a single sprite batch.
    local grassQuad, tileset = assets.quad('tileset/grass_spring.png', 144, 32, TILE, TILE)
    self.ground = love.graphics.newSpriteBatch(tileset, width * height, 'static')
    for ty = 1, height do
        for tx = 1, width do
            self.ground:add(grassQuad, self:tileToWorld(tx, ty))
        end
    end

    return self
end

function Farm:get(tx, ty)
    local row = self.tiles[ty]
    return row and row[tx]
end

--- Tile containing the world point (x, y).
function Farm:worldToTile(x, y)
    return math.floor(x / TILE) + 1, math.floor(y / TILE) + 1
end

--- Top-left world corner of a tile.
function Farm:tileToWorld(tx, ty)
    return (tx - 1) * TILE, (ty - 1) * TILE
end

function Farm:pixelSize()
    return self.width * TILE, self.height * TILE
end

function Farm:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.ground)

    for ty = 1, self.height do
        for tx = 1, self.width do
            if self.tiles[ty][tx].tilled then
                local x, y = self:tileToWorld(tx, ty)
                love.graphics.setColor(SOIL_EDGE_COLOR)
                love.graphics.rectangle('fill', x + 1, y + 1, TILE - 2, TILE - 2, 3)
                love.graphics.setColor(SOIL_COLOR)
                love.graphics.rectangle('fill', x + 2, y + 2, TILE - 4, TILE - 5, 2)
            end
        end
    end
    love.graphics.setColor(1, 1, 1)
end

return Farm
