-- Screen-space overlay: seed selection, harvest counts and controls.
local assets = require('core.assets')
local crops = require('data.crops')

local hud = {}

local SCALE = 3
local SLOT = 16 * SCALE + 12
local PADDING = 10

local font

-- The bottom 16x16 of a 16x32 crop-sheet cell holds the icon.
local function icon(def, column)
    return assets.quad(crops.SHEET, column * crops.CELL_WIDTH, def.row * crops.CELL_HEIGHT + 16, 16, 16)
end

function hud.draw(world, player)
    font = font or love.graphics.newFont(14)
    love.graphics.setFont(font)

    local inventory = world:getResource('inventory')
    local selected = player.farmer.seed

    for i, def in ipairs(crops) do
        local x, y = PADDING + (i - 1) * SLOT, PADDING

        love.graphics.setColor(0, 0, 0, 0.45)
        love.graphics.rectangle('fill', x, y, SLOT - 6, SLOT + 16, 6)
        if i == selected then
            love.graphics.setColor(1, 0.9, 0.4)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle('line', x, y, SLOT - 6, SLOT + 16, 6)
            love.graphics.setLineWidth(1)
        end

        love.graphics.setColor(1, 1, 1)
        local quad, image = icon(def, crops.SEED_COLUMN)
        love.graphics.draw(image, quad, x + 3, y + 3, 0, SCALE)
        love.graphics.print(tostring(i), x + 5, y + 3)

        local itemQuad = icon(def, crops.ITEM_COLUMN)
        love.graphics.draw(image, itemQuad, x + 3, y + SLOT - 6, 0, 1.5)
        love.graphics.print(tostring(inventory[def.id] or 0), x + 30, y + SLOT - 4)
    end

    local name = crops[selected].name
    love.graphics.print('Seed: ' .. name, PADDING, PADDING + SLOT + 22)

    local help = 'WASD/arrows: move   Space/E: till, plant, harvest   1-4 or Q: choose seed   Esc: pause'
    local h = love.graphics.getHeight()
    love.graphics.setColor(0, 0, 0, 0.45)
    love.graphics.rectangle('fill', 0, h - 28, love.graphics.getWidth(), 28)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(help, PADDING, h - 22)
end

return hud
