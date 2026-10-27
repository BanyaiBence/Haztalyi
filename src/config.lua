-- Game-wide tunables. Anything a designer might tweak belongs here.
local config = {
    WINDOW_WIDTH = 960,
    WINDOW_HEIGHT = 640,

    TILE_SIZE = 16,
    MAP_WIDTH = 40,  -- in tiles
    MAP_HEIGHT = 30,
    ZOOM = 3,

    PLAYER_SPEED = 70, -- world pixels per second
    CAMERA_STIFFNESS = 8,

    -- Each action maps to a list of keys (love.keyboard KeyConstants).
    KEYS = {
        left = { 'left', 'a' },
        right = { 'right', 'd' },
        up = { 'up', 'w' },
        down = { 'down', 's' },
        action = { 'space', 'e' },
        nextSeed = { 'q', 'tab' },
        pause = { 'escape', 'p' },
    },
}

--- True if `key` is bound to `action`.
function config.isBound(action, key)
    for _, bound in ipairs(config.KEYS[action]) do
        if bound == key then return true end
    end
    return false
end

--- True if any key bound to `action` is held down.
function config.isDown(action)
    return love.keyboard.isDown(unpack(config.KEYS[action]))
end

return config
