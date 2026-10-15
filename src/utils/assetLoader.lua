local anim8 = require('lib.anim8.anim8')

local assetLoader = {}

function assetLoader.loadImage(path)
    local success, image = pcall(love.graphics.newImage, path)
    if success then
        return image
    else
        error("Failed to load image: " .. path)
    end
end

function assetLoader.loadAnimation(path, frameWidth, frameHeight, duration)
    local image = love.graphics.newImage(path)
    local grid = anim8.newGrid(frameWidth, frameHeight, image:getWidth(), image:getHeight())
    
    local animation = anim8.newAnimation(grid('1-1', 1), duration) 
    
    return {
        image = image,
        animation = animation
    }
end

return assetLoader
