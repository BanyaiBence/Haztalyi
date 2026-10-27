-- Cached asset loading. Paths are relative to assets/graphics/.
local anim8 = require('lib.anim8.anim8')

local assets = {}

local images = {}
local quads = {}

function assets.image(path)
    if not images[path] then
        images[path] = love.graphics.newImage('assets/graphics/' .. path)
    end
    return images[path]
end

--- A cached quad for a sub-rectangle of an image. Returns quad, image.
function assets.quad(path, x, y, w, h)
    local key = table.concat({ path, x, y, w, h }, ':')
    local image = assets.image(path)
    if not quads[key] then
        quads[key] = love.graphics.newQuad(x, y, w, h, image:getDimensions())
    end
    return quads[key], image
end

--- An anim8 grid covering a whole sprite sheet. Returns grid, image.
function assets.grid(path, frameWidth, frameHeight)
    local image = assets.image(path)
    return anim8.newGrid(frameWidth, frameHeight, image:getWidth(), image:getHeight()), image
end

return assets
