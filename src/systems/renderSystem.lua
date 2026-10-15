-- systems/renderSystem.lua
local concord = require('lib.concord')
local anim8 = require('lib.anim8.anim8')

local RenderSystem = concord.system({pool = {
    'position', 'sprite'
}})

function RenderSystem:update(dt)
    -- Drawing happens in love.draw callback, but we'll use the update method
    -- for consistency with other systems, or we could override the draw method
    for _, entity in ipairs(self.pool) do
        local pos = entity:get('position')
        local sprite = entity:get('sprite')
        
        if sprite and sprite.animation then
            -- Update animation
            if sprite.animation.update then
                sprite.animation:update(dt)
            end
        end
    end
end

function RenderSystem:draw()
    for _, entity in ipairs(self.pool) do
        local pos = entity:get('position')
        local sprite = entity:get('sprite')
        if sprite.animation and sprite.spriteSheet then
            sprite.animation:draw(sprite.spriteSheet, pos.x, pos.y)
        end
    end
end

return RenderSystem
