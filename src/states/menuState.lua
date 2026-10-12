local GaneState = require('hump.gamestate')
local menuState = {}

function menuState:init()
    self.title = "Haztalyi"
    self.options = {"Start Game", "Options", "Quit"}
    self.selected = 1
end

function menuState:enter()
end

function menuState:update(dt)
end

function menuState:draw()
    love.graphics.print(self.title, 100, 100)
    for i, option in ipairs(self.options) do
        if i == self.selected then 
            love.graphics.print("> " .. option, 100, 150 + i * 30)
        else
            love.graphics.print(option, 100, 150 + i * 30)
        end
    end
end

function menuState:keypressed(key)
    if key == "up" then
        self.selected = math.max(1, self.selected - 1)
    elseif key == "down" then
        self.selected = math.min(#self.options, self.selected + 1)
    elseif key == "return" then 
        if self.selected == 1 then
            -- TODO: Switch to play state
        elseif self.selected == 3 then
            love.event.quit()
        end
    end
end

return menuState