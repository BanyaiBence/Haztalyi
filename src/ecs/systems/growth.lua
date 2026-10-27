-- Advances crops through their growth stages over time.
require('ecs.components')
local Concord = require('lib.concord')
local crops = require('data.crops')
local entities = require('ecs.entities')

local Growth = Concord.system({ pool = { 'crop', 'sprite' } })

function Growth:update(dt)
    for _, e in ipairs(self.pool) do
        local crop = e.crop
        local def = crops.byId[crop.id]
        if crop.stage < def.stages then
            crop.timer = crop.timer + dt
            if crop.timer >= def.stageTime then
                crop.timer = crop.timer - def.stageTime
                crop.stage = crop.stage + 1
                e.sprite.quad = entities.cropFrame(crop.id, crop.stage)
            end
        end
    end
end

return Growth
