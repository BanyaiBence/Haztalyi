local concord = require('concord')
local entityFactory = require('entities.entityFactory')

local HarvestSystem = concord.system({
    'position', 'planted', 'cropReference'
}, {
    'position', 'inputState'
})

local INTERACT_RANGE = 40

function HarvestSystem:update(dt, tileEntity)
    local tilePos = tileEntity:get('position')
    local isPlanted = tileEntity:get('planted').planted
    local cropRef = tileEntity:get('cropReference').entity
    
    -- Find player entity
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
    
    -- Check if player is near this tile and wants to harvest
    local dist = (tilePos.x - playerPos.x)^2 + (tilePos.y - playerPos.y)^2
    if dist < INTERACT_RANGE^2 and input.action and isPlanted and cropRef ~= nil then
        -- Check if crop is mature (growth stage 5)
        local cropStage = cropRef:get('growthStage')
        if cropStage and cropStage.stage >= 5 then
            -- Harvest the crop
            self.world:removeEntity(cropRef)
            tileEntity:get('planted').planted = false
            tileEntity:get('cropReference').entity = nil
            -- TODO: Give player resources (wheat, etc.)
        end
    end
end

return HarvestSystem
