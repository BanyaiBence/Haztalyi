local Gamestate = require('lib.hump.gamestate')
local pauseState = {}

function pauseState:init()
    self.message = "Game Paused"
    self.options = {"Resume", "Main Menu", "Quit"}
    self.selected = 1
end

function pauseState:enter()
end

function pauseState:update(dt)
    -- Handle pause menu navigation
end

function pauseState:draw()
    love.graphics.setColor(0, 0, 0, 0.5) -- Semi-transparent overlay
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1) -- Reset to white
    
    love.graphics.print(self.message, 100, 100)
    for i, option in ipairs(self.options) do
        if i == self.selected then
            love.graphics.print("> " .. option, 100, 150 + i * 30)
        else
            love.graphics.print(option, 100, 150 + i * 30)
        end
    end
end

function pauseState:keypressed(key)
    if key == "up" then
        self.selected = math.max(1, self.selected - 1)
    elseif key == "down" then
        self.selected = math.min(#self.options, self.selected + 1)
    elseif key == "return" then
        if self.selected == 1 then -- Resume
            Gamestate.pop() -- Return to previous state (play)
        elseif self.selected == 2 then -- Main Menu
            Gamestate.switch(menuState)
        elseif self.selected == 3 then -- Quit
            love.event.quit()
        end
    end
end

return pauseState
