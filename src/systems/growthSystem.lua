local concord = require('concord')
local constants = require('utils.constants')

local GrowthSystem = concord.system({
    'position', 'sprite', 'growthStage', 'growthTimer', 'cropType'
})

function GrowthSystem:update(dt, entity)
    local timer = entity:get('growthTimer')
    timer.time = timer.time + dt
    
    local stage = entity:get('growthStage')
    local constants = require('utils.constants')
    
    if timer.time >= constants.GROWTH_TIME_PER_STAGE then
        timer.time = timer.time - constants.GROWTH_TIME_PER_STAGE
        stage.stage = stage.stage + 1
        
        -- Update sprite based on new growth stage
        -- TODO: Implement sprite changing based on growth stage and crop type
        -- For now, just indicate progression
        if stage.stage >= 5 then -- Assuming 5 stages: seed, sprout, small, medium, mature
            stage.stage = 5 -- Cap at mature
        end
    end
end

return GrowthSystem
