local Gamestate = require('hump.gamestate')
local menuState = require('states.menuState')

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menuState)
end

function love.update(dt)
    -- Handled by Gamestate
end

function love.draw()
    -- Handled by Gamestate
end

function love.keypressed(key)
    -- Handled by Gamestate
end

