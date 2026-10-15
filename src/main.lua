local Gamestate = require('lib.hump.gamestate')
local concord = require('lib.concord.concord')
local menuState = require('states.menuState')
local playState = require('states.playState')

function love.load()
    world = concord.world()
    Gamestate.registerEvents()
    Gamestate.switch(menuState)
end
