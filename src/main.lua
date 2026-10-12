local Gamestate = require('hump.gamestate')
local concord = require('concord')
local menuState = require('states.menuState')
local playState = require('states.playState')

function love.load()
    world = concord.world()
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

