Rect = {}
Rect.__index = Rect

setmetatable(Rect, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function Rect.CreateNew(position, size)
    local self = setmetatable({}, Rect)

    self.position = position or vector2(0, 0)
    self.size = size or vector2(1, 1)

    return self
end

function Rect:Draw(color)
    local pos = self.position + self.size * 0.5
    DrawRect(pos.x, pos.y, self.size.x, self.size.y, color.r, color.g, color.b, color.a)
end
