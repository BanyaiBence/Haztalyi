-- Smoothly follows the player, clamped so the view never leaves the farm.
require('ecs.components')
local Concord = require('lib.concord')
local config = require('config')

local CameraSystem = Concord.system({ pool = { 'playerControlled', 'position' } })

local function clamp(value, min, max)
    if min > max then return (min + max) / 2 end -- map smaller than view: centre
    return math.max(min, math.min(max, value))
end

function CameraSystem:update(dt)
    local world = self:getWorld()
    local camera = world:getResource('camera')
    local mapWidth, mapHeight = world:getResource('farm'):pixelSize()
    local halfWidth = love.graphics.getWidth() / camera.scale / 2
    local halfHeight = love.graphics.getHeight() / camera.scale / 2

    local target = self.pool[1]
    if not target then return end

    -- Track a smooth float position, but snap the camera to whole screen
    -- pixels so pixel art doesn't shimmer.
    self.x = self.x or target.position.x
    self.y = self.y or target.position.y
    local t = math.min(1, config.CAMERA_STIFFNESS * dt)
    self.x = clamp(self.x + (target.position.x - self.x) * t, halfWidth, mapWidth - halfWidth)
    self.y = clamp(self.y + (target.position.y - self.y) * t, halfHeight, mapHeight - halfHeight)

    local scale = camera.scale
    camera:lookAt(math.floor(self.x * scale + 0.5) / scale, math.floor(self.y * scale + 0.5) / scale)
end

return CameraSystem
