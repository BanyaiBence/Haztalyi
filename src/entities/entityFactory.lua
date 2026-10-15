local concord = require('lib.concord.concord')
local component = require('lib.concord.concord.component')

local Position = component.new('position', function(self, x, y) 
    self.x = x or 0
    self.y = y or 0
end)
local Velocity = component.new('velocity', function(self, x, y) 
    self.x = x or 0
    self.y = y or 0
end)
local Sprite = component.new('sprite', function(self, animation)
    self.animation = animation or nil
end)
local InputState = component.new('inputState', function(self, left, right, up, down, action)
    self.left = left or false 
    self.right = right or false 
    self.up = up or false 
    self.down = down or false
    self.action = action or false
end)

local entityFactory = {}

function entityFactory.createPlayer(world, x, y)
    local entity = world:newEntity()
        :give('position', x, y)
        :give('velocity', 0, 0)
        :give('sprite', nil) -- Animation will be set later
        :give('inputState', {left = false, right = false, up = false, down = false, action = false})
    return entity
end


function entityFactory.createTile(world, x, y, isTilled)
    local entity = world:newEntity()
        :give('position', x, y)
    return entity
end

return entityFactory