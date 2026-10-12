-- systems/renderSystem.lua
local concord = require('concord')
local anim8 = require('anim8.anim8')

local RenderSystem = concord.system({
    'position', 'sprite'
})

function RenderSystem:update(dt, entity)
    -- Drawing happens in love.draw callback, but we'll use the update method
    -- for consistency with other systems, or we could override the draw method
    local pos = entity:get('position')
    local sprite = entity:get('sprite')
    
    if sprite and sprite.animation then
        -- Update animation
        sprite.animation:update(dt)
        -- Draw sprite
        sprite.animation:draw(sprite.spriteSheet, pos.x, pos.y)
    end
end

-- Alternative approach: override the draw method in the system
function RenderSystem:draw()
    for _, entity in ipairs(self:getEntities()) do
        local pos = entity:get('position')
        local sprite = entity:get('sprite')
        
        if sprite and sprite.animation then
            sprite.animation:draw(sprite.spriteSheet, pos.x, pos.y)
        end
    end
end

return RenderSystem
