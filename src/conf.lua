local config = require('config')

function love.conf(t)
    t.identity = 'haztalyi'
    t.version = '11.5'
    t.window.title = 'Haztalyi'
    t.window.width = config.WINDOW_WIDTH
    t.window.height = config.WINDOW_HEIGHT
    t.window.vsync = 1
end
