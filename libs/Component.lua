local Component = {}
Component.__index = Component

function Component.new(name)
    local self = setmetatable({}, Component)

    self.name = name

    return self
end

return Component
