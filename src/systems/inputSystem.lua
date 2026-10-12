local concord = require('concord')
local InputSystem = concord.system({})

function InputSystem:init()
    self.pressedKeys = {}
end

function InputSystem:update(dt, entity)
    local input = entity:get('InputState')
    if not input then return end
    
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

function InputSystem:keypressed(key)
    self.pressedKeys[key] = true
end

function InputSystem:keyreleased(key)
    self.pressedKeys[key] = false
end

return InputSystem
