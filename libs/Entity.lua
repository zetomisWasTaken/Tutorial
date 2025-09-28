local Entity = {}
Entity.__index = Entity

function Entity.new()
    local self = setmetatable({}, Entity)

    self.components = {}

    return self
end

function Entity:addComponent(component)
    self.components[component.name] = component
end

function Entity:removeComponent(componentName)
    self.components[componentName] = nil
end

function Entity:getComponent(componentName)
    return self.components[componentName]
end

return Entity
