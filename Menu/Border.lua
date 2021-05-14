Border = {}
Border.__index = Border

setmetatable(Border, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function Border.CreateNew(position, size, thickness, color)
    local self = setmetatable({}, Border)

    self.position = position or vector2(0, 0)
    self.size = size or vector2(0, 0)
    self.thickness = thickness or 0.001
    self.color = color or Colors.Grey
    
    self.rects = {}

    return self
end

function Border:SetPositionAndSize(position, size)
    local aspectRatio = GetAspectRatio(false)

    self.position = position
    self.size = size

    self.rects = {
        Rect(self.position, vector2(self.thickness, self.size.y)),
        Rect(self.position + vector2(self.size.x, 0), vector2(self.thickness, self.size.y + self.thickness)),
        Rect(self.position, vector2(self.size.x, self.thickness * aspectRatio)),
        Rect(self.position + vector2(0, self.size.y), vector2(self.size.x + self.thickness, self.thickness * aspectRatio))
    }
end

function Border:Draw()
    for i = 1, #self.rects, 1 do
        self.rects[i]:Draw(self.color)
    end
end
