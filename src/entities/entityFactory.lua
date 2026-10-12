local concord = require('concord')
local component = require('concord.component')

local Position = component.new('position', {x = 0, y = 0})
local Velocity = component.new('velocity', {x = 0, y = 0})
local Sprite = component.new('sprite', {animation = nil})
local InputState = component.new('inputState', {left = false, right = false, up = false, down = false, action = false})

local entityFactory = {}

function entityFactory.createPlayer(world, x, y)
    local entity = world:newEntity()
        :give(Position, x, y)
        :give(Velocity, 0, 0)
        :give(Sprite, nil) -- Animation will be set later
        :give(InputState, {left = false, right = false, up = false, down = false, action = false})
    return entity
end

function entityFactory.createCrop(world, x, y, cropType)
    local entity = world:newEntity()
        :give(Position, x, y)
        :give(Sprite, nil)
        :give('growthStage', {stage = 0}) -- 0 = seed
        :give('growthTimer', {time = 0})
        :give('cropType', {type = cropType})
    return entity
end

function entityFactory.createTile(world, x, y, isTilled)
    local entity = world:newEntity()
        :give(Position, x, y)
        :give('tilled', {tilled = isTilled})
        :give('planted', {planted = false})
        :give('cropReference', {entity = nil})
    return entity
end

return entityFactory