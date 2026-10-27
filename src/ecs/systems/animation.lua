-- Picks the right animation from movement state and feeds frames to sprites.
require('ecs.components')
local Concord = require('lib.concord')

local Animation = Concord.system({ pool = { 'animator', 'sprite' } })

local function play(animator, name)
    if animator.current ~= name then
        animator.current = name
        animator.animations[name].anim:gotoFrame(1)
    end
end

function Animation:update(dt)
    for _, e in ipairs(self.pool) do
        local animator, sprite = e.animator, e.sprite

        if e.facing and e.velocity then
            local dir = e.facing.dir
            local moving = e.velocity.x ~= 0 or e.velocity.y ~= 0
            local row = (dir == 'left' or dir == 'right') and 'side' or dir
            play(animator, (moving and 'walk_' or 'idle_') .. row)
            sprite.flipX = dir == 'left'
        end

        local current = animator.animations[animator.current]
        current.anim:update(dt)
        sprite.image = current.image
        sprite.quad = current.anim.frames[current.anim.position]
    end
end

return Animation
