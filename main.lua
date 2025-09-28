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
    for _, s in ipairs(game.systems) do
        s:update(dt, game.entities)
    end
end

function love.draw()
    for _, s in ipairs(game.systems) do
        s:draw(game.entities)
    end
end
