local Gamestate = require('lib.hump.gamestate')
local menuList = require('ui.menuList')

local menu = {}

function menu:init()
    self.list = menuList.new('Haztalyi', {
        -- Required lazily: play -> pause -> menu would otherwise be a require cycle.
        { label = 'New Game', run = function() Gamestate.switch(require('states.play')) end },
        { label = 'Quit', run = function() love.event.quit() end },
    })
end

function menu:draw()
    love.graphics.clear(0.18, 0.32, 0.2)
    self.list:draw()
end

function menu:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        self.list:keypressed(key)
    end
end

return menu
