local Vector = require "libs.Vector"
local game = {
    entities = {},
    systems = {}
}

function love.load()
    for _, e in ipairs(game.entities) do
        s:load(game.entities)
    end
end

function love.update(dt)
    print((Vector(love.mouse.getPosition()) - Vector(100, 100)):angle())

    for _, s in ipairs(game.systems) do
        s:update(dt, game.entities)
    end
end

function love.draw()
    love.graphics.circle("fill", 100, 100, 2)

    for _, s in ipairs(game.systems) do
        s:draw(game.entities)
    end
end
