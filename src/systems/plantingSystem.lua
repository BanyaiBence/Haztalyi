dlocal concord = require('concord')
local entityFactory = require('entities.entityFactory')

local PlantingSystem = concord.system({
    'position', 'tilled', 'planted', 'cropReference'
}, {
    'position', 'inputState'
})

local INTERACT_RANGE = 40 -- pixels

function PlantingSystem:update(dt, tileEntity)
    local tilePos = tileEntity:get('position')
    local isTilled = tileEntity:get('tilted').tilled
    local isPlanted = tileEntity:get('planted').planted
    
    -- Find player entity (assuming there's only one for simplicity)
    local playerEntity = nil
    for _, entity in ipairs(self.world:getEntities()) do
        if entity:has('inputState') then
            playerEntity = entity
            break
        end
    end
    
    if not playerEntity then return end
    
    local playerPos = playerEntity:get('position')
    local input = playerEntity:get('inputState')
    
    -- Check if player is near this tile and wants to plant
    local dist = (tilePos.x - playerPos.x)^2 + (tilePos.y - playerPos.y)^2
    if dist < INTERACT_RANGE^2 and input.action and isTilled and not isPlanted then
        -- Plant a crop (default to wheat for now)
        local crop = entityFactory.createCrop(self.world, tilePos.x, tilePos.y, "wheat")
        tileEntity:get('planted').planted = true
        tileEntity:get('cropReference').entity = crop
    end
end

return PlantingSystem
