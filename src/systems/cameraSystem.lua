local concord = require('lib.concord')
local camera = require('lib.hump.camera')

local CameraSystem = concord.system({pool = {
    'position'
}})

local SMOOTHNESS = 0.1

function CameraSystem:init()
    self.cam = camera()
end

function CameraSystem:update(dt)
    for _, entity in ipairs(self.pool) do
        local pos = entity:get('position')
        self.cam:lookAt(pos.x, pos.y)
    end
end

function CameraSystem:draw()
    self.cam:attach()
    -- Drawing of game world happens here
    -- Entities will draw themselves in their systems or render system
    self.cam:detach()
end

return CameraSystem