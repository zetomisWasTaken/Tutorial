local System = {}
System.__index = System

function System.new()
    local self = setmetatable({}, System)

    return self
end

function System:load(entities)
end

function System:update(dt, entities)
end

function System:draw(entities)
end

return System
