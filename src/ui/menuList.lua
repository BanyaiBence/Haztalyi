-- A vertical list of options navigated with up/down and confirmed with enter.
-- options: array of { label = string, run = function() }.
local menuList = {}
menuList.__index = menuList

local fonts = {}
local function font(size)
    fonts[size] = fonts[size] or love.graphics.newFont(size)
    return fonts[size]
end

function menuList.new(title, options)
    return setmetatable({ title = title, options = options, selected = 1 }, menuList)
end

function menuList:keypressed(key)
    if key == 'up' or key == 'w' then
        self.selected = (self.selected - 2) % #self.options + 1
    elseif key == 'down' or key == 's' then
        self.selected = self.selected % #self.options + 1
    elseif key == 'return' or key == 'space' or key == 'kpenter' then
        self.options[self.selected].run()
    end
end

function menuList:draw()
    local width, height = love.graphics.getDimensions()
    local top = height / 2 - 120

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(font(48))
    love.graphics.printf(self.title, 0, top, width, 'center')

    love.graphics.setFont(font(22))
    for i, option in ipairs(self.options) do
        local label = i == self.selected and ('> ' .. option.label .. ' <') or option.label
        love.graphics.setColor(1, 1, 1, i == self.selected and 1 or 0.6)
        love.graphics.printf(label, 0, top + 100 + i * 36, width, 'center')
    end
    love.graphics.setColor(1, 1, 1)
end

return menuList
