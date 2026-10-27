local Gamestate = require('lib.hump.gamestate')

function love.load()
    -- Pixel art: never blur when scaling.
    love.graphics.setDefaultFilter('nearest', 'nearest')

    Gamestate.registerEvents()
    Gamestate.switch(require('states.menu'))
end
