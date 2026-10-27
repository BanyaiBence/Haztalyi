-- Pushed on top of play; draws the frozen game underneath a dim overlay.
local Gamestate = require('lib.hump.gamestate')
local config = require('config')
local menuList = require('ui.menuList')

local pause = {}

function pause:init()
    self.list = menuList.new('Paused', {
        { label = 'Resume', run = function() Gamestate.pop() end },
        { label = 'Main Menu', run = function()
            Gamestate.pop()
            Gamestate.switch(require('states.menu'))
        end },
        { label = 'Quit', run = function() love.event.quit() end },
    })
end

function pause:enter(from)
    self.from = from
    self.list.selected = 1
end

function pause:draw()
    self.from:draw()
    love.graphics.setColor(0, 0, 0, 0.55)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getDimensions())
    self.list:draw()
end

function pause:keypressed(key)
    if config.isBound('pause', key) then
        Gamestate.pop()
    else
        self.list:keypressed(key)
    end
end

return pause
