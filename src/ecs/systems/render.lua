-- Draws the world through the camera: ground, tile cursor, then sprites
-- sorted by y so things lower on screen overlap things behind them.
require('ecs.components')
local Concord = require('lib.concord')
local config = require('config')

local Render = Concord.system({
    drawables = { 'position', 'sprite' },
    farmers = { 'farmer' },
})

local function byDepth(a, b)
    return a.position.y < b.position.y
end

function Render:init()
    self.sorted = {}
end

function Render:draw()
    local world = self:getWorld()
    local camera = world:getResource('camera')
    local farm = world:getResource('farm')

    camera:attach()

    farm:draw()

    -- Highlight the tile each farmer would act on.
    love.graphics.setColor(1, 1, 1, 0.6)
    for _, e in ipairs(self.farmers) do
        if e.farmer.tx then
            local x, y = farm:tileToWorld(e.farmer.tx, e.farmer.ty)
            love.graphics.rectangle('line', x + 0.5, y + 0.5, config.TILE_SIZE - 1, config.TILE_SIZE - 1)
        end
    end
    love.graphics.setColor(1, 1, 1)

    local sorted = self.sorted
    for i = #sorted, 1, -1 do sorted[i] = nil end
    for i, e in ipairs(self.drawables) do sorted[i] = e end
    table.sort(sorted, byDepth)

    for _, e in ipairs(sorted) do
        local s = e.sprite
        if s.image and s.quad then
            love.graphics.draw(s.image, s.quad,
                math.floor(e.position.x + 0.5), math.floor(e.position.y + 0.5),
                0, s.flipX and -1 or 1, 1, s.ox, s.oy)
        end
    end

    camera:detach()
end

return Render
