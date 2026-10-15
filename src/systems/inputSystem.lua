local concord = require('lib.concord')

-- 1. Define a named pool that tracks entities with the 'inputState' component
local InputSystem = concord.system({
    pool = {'inputState'} 
})

function InputSystem:init()
    self.pressedKeys = {}
end

-- 2. Remove 'entity' from the parameters
function InputSystem:update(dt)
    -- 3. Loop through the pool of matching entities
    for _, entity in ipairs(self.pool) do
        local input = entity:get('inputState')
        -- Note: You can also just write `local input = entity.inputState`
        
        -- Reset input state each frame
        input.left = false
        input.right = false
        input.up = false
        input.down = false
        input.action = false
        
        -- Check currently pressed keys
        if self.pressedKeys['left'] or self.pressedKeys['a'] then
            input.left = true
        end
        if self.pressedKeys['right'] or self.pressedKeys['d'] then
            input.right = true
        end
        if self.pressedKeys['up'] or self.pressedKeys['w'] then
            input.up = true
        end
        if self.pressedKeys['down'] or self.pressedKeys['s'] then
            input.down = true
        end
        if self.pressedKeys['space'] then
            input.action = true
        end
    end
end

function InputSystem:keypressed(key)
    self.pressedKeys[key] = true
end

function InputSystem:keyreleased(key)
    self.pressedKeys[key] = false
end

return InputSystem