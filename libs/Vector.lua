local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    local self = setmetatable({}, Vector)

    self.x = x or 0
    self.y = y or 0

    return self
end

setmetatable(Vector, {
    __call = function(_, x, y) return Vector.new(x, y) end
})

local function isVector(v)
    return type(v) == "table" and getmetatable(v) == Vector
end

local function clamp(x, lo, hi)
    if x < lo then return lo end
    if x > hi then return hi end

    return x
end

function Vector.__add(a, b)
    assert(isVector(a) and isVector(b), "attempt to add non-vectors")
    return Vector.new(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
    assert(isVector(a) and isVector(b), "attempt to subtract non-vectors")
    return Vector.new(a.x - b.x, a.y - b.y)
end

function Vector.__mul(a, b)
    if type(a) == "number" and isVector(b) then
        return Vector.new(a * b.x, a * b.y)
    elseif isVector(a) and type(b) == "number" then
        return Vector.new(a.x * b, a.y * b)
    elseif isVector(a) and isVector(b) then
        return Vector.new(a.x * b.x, a.y * b.y)
    end
    error("attempt to multiply incompatible types")
end

function Vector.__div(a, b)
    if isVector(a) and type(b) == "number" then
        return Vector.new(a.x / b, a.y / b)
    elseif type(a) == "number" and isVector(b) then
        return Vector.new(a / b.x, a / b.y)
    end
    error("attempt to divide incompatible types")
end

function Vector.__unm(a)
    assert(isVector(a), "attempt to unary minus non-vector")
    return Vector.new(-a.x, -a.y)
end

function Vector.__eq(a, b)
    if not (isVector(a) and isVector(b)) then return false end
    return a.x == b.x and a.y == b.y
end

function Vector.__tostring(v)
    return ("Vector(%.6g, %.6g)"):format(v.x, v.y)
end

function Vector:clone()
    return Vector.new(self.x, self.y)
end

function Vector:unpack()
    return self.x, self.y
end

function Vector:len2()
    return self.x * self.x + self.y * self.y
end

function Vector:len()
    return math.sqrt(self:len2())
end

function Vector:normalize()
    local l = self:len()
    if l > 0 then
        self.x = self.x / l
        self.y = self.y / l
    end
    return self
end

function Vector:normalized()
    local l = self:len()
    if l > 0 then
        return Vector.new(self.x / l, self.y / l)
    end
    return Vector.new(0, 0)
end

function Vector:dot(b)
    assert(isVector(b), "dot expects a vector")
    return self.x * b.x + self.y * b.y
end

function Vector:cross(b)
    assert(isVector(b), "cross expects a vector")
    return self.x * b.y - self.y * b.x
end

function Vector:distanceTo(b)
    assert(isVector(b), "distanceTo expects a vector")
    return (self - b):len()
end

function Vector:angle()
    local right = Vector.RIGHT

    local sl = self:len()
    local rl = right:len()

    if sl == 0 or rl == 0 then return 0 end

    local cosang = clamp(self:dot(right) / (sl * rl), -1, 1)
    local ang = math.acos(cosang)

    local c = right:cross(self)
    if c < 0 then
        ang = -ang
    end

    return ang
end

function Vector:rotate(theta)
    local c = math.cos(theta)
    local s = math.sin(theta)
    local nx = self.x * c - self.y * s
    local ny = self.x * s + self.y * c
    self.x = nx
    self.y = ny
    return self
end

function Vector:rotated(theta)
    local c = math.cos(theta)
    local s = math.sin(theta)
    return Vector.new(self.x * c - self.y * s, self.x * s + self.y * c)
end

function Vector:mul(s)
    assert(type(s) == "number", "mul expects a number")
    self.x = self.x * s
    self.y = self.y * s
    return self
end

function Vector:div(s)
    assert(type(s) == "number", "div expects a number")
    self.x = self.x / s
    self.y = self.y / s
    return self
end

function Vector.scaled(v, s)
    assert(isVector(v) and type(s) == "number", "scaled expects (vector, number)")
    return Vector.new(v.x * s, v.y * s)
end

function Vector.fromAngle(angle, magnitude)
    magnitude = magnitude or 1
    return Vector.new(math.cos(angle) * magnitude, math.sin(angle) * magnitude)
end

function Vector.lerp(a, b, t)
    assert(isVector(a) and isVector(b) and type(t) == "number", "lerp expects (vector, vector, number)")
    return Vector.new(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t)
end

Vector.ZERO = Vector(0, 0)
Vector.RIGHT = Vector(1, 0)
Vector.LEFT = Vector(-1, 0)
Vector.DOWN = Vector(0, 1)
Vector.UP = Vector(0, -1)

return Vector
