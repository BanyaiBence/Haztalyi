-- Every component in the game, registered with Concord exactly once.
-- Systems and factories require this module before referring to components.
local Concord = require('lib.concord')
local component = Concord.component

-- World position of an entity's "feet". Sprites and colliders anchor here,
-- and the render system sorts by y so lower entities draw in front.
component('position', function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end)

component('velocity', function(c, x, y)
    c.x = x or 0
    c.y = y or 0
end)

-- Axis-aligned box, horizontally centred on position.x, bottom at position.y.
-- Entities with a collider are solid in the bump world.
component('collider', function(c, w, h)
    c.w = w
    c.h = h
end)

-- One of 'down', 'up', 'left', 'right'.
component('facing', function(c, dir)
    c.dir = dir or 'down'
end)

-- What a controller (keyboard now, maybe AI later) wants this frame.
-- action and nextSeed are one-shot flags, cleared by whoever consumes them.
component('intent', function(c)
    c.dx = 0
    c.dy = 0
    c.action = false
    c.nextSeed = false
    c.selectSeed = nil
end)

-- Tag: driven by the keyboard and followed by the camera.
component('playerControlled')

-- Can work the land. tx/ty is the tile in front of it, updated each frame.
component('farmer', function(c)
    c.seed = 1 -- index into data/crops
    c.tx = nil
    c.ty = nil
end)

component('sprite', function(c, image, quad, ox, oy)
    c.image = image
    c.quad = quad
    c.ox = ox or 0
    c.oy = oy or 0
    c.flipX = false
end)

-- animations: name -> { image = Image, anim = anim8 Animation }.
-- The animation system copies the current frame into the sprite component.
component('animator', function(c, animations, current)
    c.animations = animations
    c.current = current
end)

component('crop', function(c, id, tx, ty)
    c.id = id
    c.tx = tx
    c.ty = ty
    c.stage = 1
    c.timer = 0
end)
